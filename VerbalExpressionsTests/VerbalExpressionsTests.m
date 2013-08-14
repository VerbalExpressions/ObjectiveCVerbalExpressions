//
//  VerbalExpressionsTests.m
//  VerbalExpressionsTests
//
//  Created by kishikawa katsumi on 2013/08/12.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "VerbalExpressionsTests.h"
#import "VerbalExpressions.h"

@implementation VerbalExpressionsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testStartOfLine
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"a");
    
    STAssertTrue(verEx.test(@"a"), @"starts with a");
    STAssertFalse(verEx.test(@"ba"), @"doesn't start with a");
}

- (void)testEndOfLine
{
    VerbalExpressions *verEx = VerEx().find(@"a").endOfLine(YES);
    
    STAssertTrue(verEx.test(@"a"), @"ends with a");
    STAssertFalse(verEx.test(@"ab"), @"doesn't end with a");
}

- (void)testMaybe
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"a").maybe(@"b");
    
    STAssertTrue(verEx.test(@"acb"), @"maybe has a b after an a");
    STAssertTrue(verEx.test(@"abc"), @"maybe has a b after an a");
}

- (void)testAnything
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).anything();
    
    STAssertTrue(verEx.test(@"what"), @"anything is matched");
}

- (void)testAnythingBut
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).anythingBut(@"w");
    
    STAssertTrue(verEx.test(@"what"), @"starts with w");
}

- (void)testSomething
{
    VerbalExpressions *verEx = VerEx().something();
    
    STAssertFalse(verEx.test(@""), @"empty string doesn't have something");
    STAssertTrue(verEx.test(@"a"), @"a is something");
}

- (void)testSomethingBut
{
    VerbalExpressions *verEx = VerEx().somethingBut(@"a");
    
    STAssertFalse(verEx.test(@""), @"empty string doesn't have something");
    STAssertTrue(verEx.test(@"b"), @"doesn't start with a");    
    STAssertFalse(verEx.test(@"a"), @"starts with a");
}

- (void)testReplace
{
    NSString *testString = @"replace bird with a duck";
    
    VerbalExpressions *verEx = VerEx().find(@"bird");
    
    NSString *testStringAfterReplacement = verEx.replace(testString, @"duck");
    NSString *expectedStringAfterReplacement = @"replace duck with a duck";
    
    STAssertEqualObjects(testStringAfterReplacement, expectedStringAfterReplacement, @"replaced 'bird' with 'duck'");
}

- (void)testLineBreak
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"abc").lineBreak().then(@"def");
    
    STAssertTrue(verEx.test(@"abc\r\ndef"), @"abc then line break then def");
    STAssertFalse(verEx.test(@"abc\r\n def"), @"abc then line break then space then def");
}

- (void)testBR
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"abc").lineBreak().then(@"def");
    
    STAssertTrue(verEx.test(@"abc\r\ndef"), @"abc then line break then def");
    STAssertFalse(verEx.test(@"abc\r\n def"), @"abc then line break then space then def");
}

- (void)testTab
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).tab().then(@"abc");
    
    STAssertTrue(verEx.test(@"\tabc"), @"tab then abc");
    STAssertFalse(verEx.test(@"abc"), @"no tab then abc");
}

- (void)testAnyOf
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"a").anyOf(@"xyz");
    
    STAssertTrue(verEx.test(@"ay"), @"has an x, y, or z after a");
    STAssertFalse(verEx.test(@"abc"), @"doesn't have an x, y, or z after a");
}

- (void)testWithAnyCase
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"a");
    
    STAssertFalse(verEx.test(@"A"), @"not case insensitive");
    
    verEx.withAnyCase(YES);
    
    STAssertTrue(verEx.test(@"A"), @"case insensitive");
    STAssertTrue(verEx.test(@"a"), @"case insensitive");
}

- (void)testSearchOneLine
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"a").br().then(@"b").endOfLine(YES);
    
    STAssertTrue(verEx.test(@"a\nb"), @"b is on the second line");
    
    verEx.searchOneLine(YES);
    
    STAssertTrue(verEx.test(@"a\nb"), @"b is on the second line but we are only searching the first");
}

- (void)testOr
{
    VerbalExpressions *verEx = VerEx().startOfLine(YES).then(@"abc").or(@"def");
    
    STAssertTrue(verEx.test(@"defzzz"), @"starts with abc or def");
    STAssertFalse(verEx.test(@"xyzabc"), @"doesn't start with abc or def");
}

- (void)testCapture
{
    NSString *text = @"Jerry scored 5 goals!";
    VerbalExpressions *verEx = VerEx().startOfLine(YES).beginCapture().word().endCapture();
    NSRegularExpression *regex = verEx.regularExpression;
    NSTextCheckingResult *match = [regex firstMatchInString:text options:kNilOptions range:NSMakeRange(0, text.length)];
    STAssertEqualObjects([text substringWithRange:[match rangeAtIndex:1]], @"Jerry", @"successfully captures player by index");
}

- (void)testURL
{
    VerbalExpressions *verEx = VerEx()
    .startOfLine(YES)
    .find(@"http")
    .maybe(@"s")
    .find(@"://")
    .maybe(@"www")
    .anythingBut(@" ")
    .endOfLine(YES);
    
    STAssertEqualObjects(verEx.description, @"^(http)(s)?(:\\/\\/)(www)?([^ ]*)$", @"successfully builds regex for matching URLs");
    STAssertTrue(verEx.test(@"http://google.com"), @"matches regular http URL");
    STAssertTrue(verEx.test(@"https://google.com"), @"matches https URL");
    STAssertTrue(verEx.test(@"https://www.google.com"), @"matches a URL with www");
    STAssertFalse(verEx.test(@"http://goo gle.com"), @"fails to match when URL has a space");
    STAssertFalse(verEx.test(@"htp://google.com"), @"fails to match with htp:// is malformed");
}

@end
