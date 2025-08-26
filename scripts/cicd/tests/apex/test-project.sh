classNames=""
classNamesFile=$(mktemp)
grep -rl "@isTest" . --include "*.cls" | while read -r file; do
    # Extract the class name from the file (look for "public|private|global class CLASSNAME")
    classname=$(grep -E "class[[:space:]]+[A-Za-z0-9_]+" "$file" | head -n 1 | awk '{for (i=1;i<=NF;i++) if ($i=="class") print $(i+1)}')

    if [[ -n "$classname" ]]; then
        classNames="$classNames --tests $classname"
    fi
    echo "$classNames" > $classNamesFile
done
classNames=$(cat $classNamesFile)

rm -rf test-results
testRunCode=0
sf apex run test \
    --test-level RunSpecifiedTests \
    $classNames \
    --output-dir test-results \
    --code-coverage \
    --detailed-coverage \
    --wait 10 || testRunCode=$?

cat test-results/test-result.txt

exit $testRunCode