AUTHFILE="${1:-auth.txt}"
ALIAS="${2:-gmail}"

echo $AUTHFILE
echo $ALIAS

sf auth sfdxurl store --sfdx-url-file auth.txt --alias gmail
sf config set target-org=gmail