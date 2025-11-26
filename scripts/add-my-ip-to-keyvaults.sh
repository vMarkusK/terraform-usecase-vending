#!/usr/bin/env bash
set -euo pipefail

# Adds the caller's public IPv4 address to all Azure KeyVaults' ipRules without
# removing existing entries. Uses Azure CLI and jq.
# Usage:
#   ./scripts/add-my-ip-to-keyvaults.sh [--subscription SUB_ID_OR_NAME] [--dry-run]
# Requirements: az, jq, curl

print_help() {
  cat <<'EOF'
Usage: add-my-ip-to-keyvaults.sh [--subscription SUB] [--dry-run] [--help]

Options:
  --subscription SUB   Set the Azure subscription (id or name) to operate in
  --dry-run            Show what would be changed, but don't update KeyVaults
  --help               Show this help and exit

This script will discover all KeyVaults in the selected subscription and
ensure your current public IPv4 is present in each vault's networkAcls.ipRules
without removing any existing entries.
EOF
}

DRY_RUN=0
SUB=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subscription)
      SUB="$2"; shift 2;;
    --dry-run)
      DRY_RUN=1; shift;;
    --help|-h)
      print_help; exit 0;;
    *)
      echo "Unknown arg: $1" >&2; print_help; exit 2;;
  esac
done

# dependency checks
for bin in az jq curl; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "Error: required command '$bin' not found in PATH." >&2
    exit 3
  fi
done

# optionally set subscription
if [[ -n "$SUB" ]]; then
  echo "Setting subscription to: $SUB"
  az account set -s "$SUB"
fi

# get current subscription id for later use in REST calls if needed
CURRENT_SUB=$(az account show --query id -o tsv)
if [[ -z "$CURRENT_SUB" ]]; then
  echo "Could not determine current subscription. Are you logged into az?" >&2
  exit 4
fi

# get public IPv4
MYIP=$(curl -fsS https://checkip.amazonaws.com || true)
if [[ -z "$MYIP" ]]; then
  echo "Failed to determine public IP via checkip.amazonaws.com. Trying fallback..." >&2
  MYIP=$(dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null || true)
fi
if [[ -z "$MYIP" ]]; then
  echo "Could not determine public IP address. Ensure you have network access." >&2
  exit 5
fi
MYIP=${MYIP%%$'\n'}

echo "Using public IP: $MYIP"

# gather vaults (name and resourceGroup)
mapfile -t VAULT_LINES < <(az keyvault list --query "[].{name:name,rg:resourceGroup}" -o tsv)
if [[ ${#VAULT_LINES[@]} -eq 0 ]]; then
  echo "No KeyVaults found in subscription $CURRENT_SUB"; exit 0
fi

added_count=0
skipped_count=0
failed_count=0

for entry in "${VAULT_LINES[@]}"; do
  # Each entry is: <name><tab><resourceGroup>
  name=$(printf '%s' "$entry" | awk -F"\t" '{print $1}')
  rg=$(printf '%s' "$entry" | awk -F"\t" '{print $2}')

  echo "\nProcessing KeyVault: $name (rg: $rg)"

  # read existing ipRules array (may be null)
  existing_json=$(az keyvault show -n "$name" -g "$rg" --query "properties.networkAcls.ipRules" -o json 2>/dev/null || echo "null")

  # create merged JSON array: if null -> [{value:MYIP}] ; if exists and contains MYIP -> no-op ; otherwise append
  merged_json=$(jq -c --arg ip "$MYIP" 'if . == null then [{value:$ip}] elif any(.[]; .value == $ip) then . else (. + [{value:$ip}]) end' <<<"$existing_json")
  if [[ -z "$merged_json" ]]; then
    echo "Failed to compute merged ipRules for $name"; failed_count=$((failed_count+1)); continue
  fi

  # detect whether MYIP was already present
  present=$(jq -e --arg ip "$MYIP" 'any(.[]; .value == $ip)' <<<"$existing_json" >/dev/null 2>&1 && echo yes || echo no)
  if [[ "$present" == "yes" ]]; then
    echo " - IP $MYIP already present; skipping."
    skipped_count=$((skipped_count+1))
    continue
  fi

  echo " - Will add IP $MYIP to $name"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "DRY RUN: az keyvault update -n $name -g $rg --set properties.networkAcls.ipRules='$merged_json'"
    added_count=$((added_count+1))
    continue
  fi

  # apply update
  if az keyvault update -n "$name" -g "$rg" --set "properties.networkAcls.ipRules=$merged_json" >/dev/null; then
    echo " - Updated $name (added $MYIP)"
    added_count=$((added_count+1))
  else
    echo " - ERROR: failed to update $name"; failed_count=$((failed_count+1))
  fi
done

echo "\nSummary: added=$added_count skipped=$skipped_count failed=$failed_count"

if [[ "$failed_count" -gt 0 ]]; then
  exit 6
fi

exit 0
