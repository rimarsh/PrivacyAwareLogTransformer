echo "Testing for build failure with disallowed API use."
sed -i -e 's/exclude: \[\"BuildFailureTests.swift\"\]/exclude: \[\"\"\]/g' Package.swift
swift test -v
status=$?
sed -i -e 's/exclude: \[\"\"\]/exclude: \[\"BuildFailureTests.swift\"\]/g' Package.swift

if [ $status -eq 0 ]; then
    echo "Build succeeded, it should have failed in BuildFailureTests.swift."
    exit -1
else
    echo "Build failed as expected."
fi
