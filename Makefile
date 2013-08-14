PROJECT = VerbalExpressions.xcodeproj
TEST_TARGET = VerbalExpressionsTests

test:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		clean build \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		TEST_HOST=""
		
test-with-coverage:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		clean build \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		TEST_HOST="" \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
send-coverage:
	coveralls \
		-e VerbalExpressions \
		-e VerbalExpressionsTests \
		--verbose
