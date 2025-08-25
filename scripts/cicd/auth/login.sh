AUTHFILE="${1:-auth.txt}"
ALIAS="${2:-gmail}"

sf auth sfdxurl store --sfdx-url-file $AUTHFILE --alias $ALIAS
sf config set target-org=$ALIAS