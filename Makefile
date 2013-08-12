PROJECT = VerbalExpressions.xcodeproj
TEST_TARGET = VerbalExpressionsTests

test:
	xcodebuild \
		-project $(PROJECT) \
		-sdk iphonesimulator \
		-scheme Tests \
		-configuration Debug \
		clean build \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES
		
test-with-coverage:
	xcodebuild \
		-project $(PROJECT) \
		-sdk iphonesimulator \
		-scheme Tests \
		-configuration Debug \
		clean build \
		ONLY_ACTIVE_ARCH=NO \
		TEST_AFTER_BUILD=YES \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
		
send-coverage:
	coveralls \
		--verbose