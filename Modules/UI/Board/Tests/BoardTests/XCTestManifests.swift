import XCTest

#if !canImport(ObjectiveC)
    /// .
    public func allTests() -> [XCTestCaseEntry]
    {
        [
            testCase(UITests.allTests)
        ]
    }
#endif
