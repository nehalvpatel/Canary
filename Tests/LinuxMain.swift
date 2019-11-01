import XCTest

import CanaryTests

var tests = [XCTestCaseEntry]()
tests += CanaryTests.allTests()
XCTMain(tests)
