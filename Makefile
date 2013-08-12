PROJECT = VerbalExpressions.xcodeproj
TEST_TARGET = VerbalExpressionsTests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-configuration Debug \
		TEST_AFTER_BUILD=YES
		
test-with-coverage:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-configuration Debug \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
send-coverage:
	coveralls \
		--verbose