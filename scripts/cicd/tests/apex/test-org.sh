rm -rf test-results # Clear Existing Tests

testRunCode=0
sf apex run test \
    --test-level RunLocalTests \
    --output-dir test-results \
    --code-coverage \
    --detailed-coverage \
    --wait 10 || testRunCode=$?

# Display Tests
cat test-results/test-result.txt
testRunId=$(cat test-results/test-run-id.txt)
testResultsFileName="test-results/test-result-$testRunId.json"

exit $testRunCode