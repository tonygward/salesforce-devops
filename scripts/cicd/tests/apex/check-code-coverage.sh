
# Usage: ./check-class-coverage.sh [coverage.json] [threshold]
FILE="${1:-test-results/test-result-codecoverage.json}"
THRESHOLD="${2:-75}"

if ! command -v jq >/dev/null; then
  echo "jq is required but not installed" >&2
  exit 2
fi
[ -f "$FILE" ] || { echo "Coverage file not found: $FILE" >&2; exit 2; }

# Build a list of classes with pct < threshold (works with raw array or sf CLI shape)
violations_json=$(
  jq --argjson th "$THRESHOLD" '
    (if type=="array" then .
     elif has("coverage") and (.coverage|type=="array") then .coverage
     elif has("coverage") and (.coverage|has("coverage")) then .coverage.coverage
     else . end)
    | map({
        name: .name,
        pct: ( if (.coveredPercent? != null) then (.coveredPercent|tonumber)
               elif (.totalCovered? != null and .totalLines? != null and (.totalLines|tonumber) > 0)
                 then ((.totalCovered|tonumber) * 100 / (.totalLines|tonumber))
               else null end )
      })
    | map(select(.pct != null and .pct < $th))
  ' "$FILE"
)

count=$(jq 'length' <<<"$violations_json")

if [ "$count" -gt 0 ]; then
  echo "❌ Classes below ${THRESHOLD}% coverage:"
  jq -r '.[] | [.name, (.pct)] | @tsv' <<<"$violations_json" \
    | awk -F'\t' '{printf "- %s: %.2f%%\n", $1, $2}'

  # Optional: surface in GitHub Actions summary
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "## Classes below ${THRESHOLD}% coverage"
      echo ""
      echo "| Class | Coverage |"
      echo "|---|---:|"
      jq -r '.[] | [.name, (.pct)] | @tsv' <<<"$violations_json" \
        | awk -F'\t' '{printf "| %s | %.2f%% |\n", $1, $2}'
    } >> "$GITHUB_STEP_SUMMARY"
  fi
  exit 1
else
  echo "✅ All classes meet the ${THRESHOLD}% coverage threshold."
fi