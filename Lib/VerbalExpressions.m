//
//  VerbalExpressions.m
//  VerbalExpressions
//
//  Created by kishikawa katsumi on 2013/08/11.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "VerbalExpressions.h"

@interface VerbalExpressions ()

@property (nonatomic) NSString *prefixes;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *suffixes;
@property (nonatomic) NSString *pattern;
@property (nonatomic) NSRegularExpressionOptions modifiers;

@property (nonatomic, readonly) VerbalExpressions *(^add)(NSString *value);

@end

@implementation VerbalExpressions

+ (VerbalExpressions *)instantiate:(void (^)(VerbalExpressions *))block
{
    VerbalExpressions *verEx = VerEx();
    if (block) {
        block(verEx);
    }
    
    return verEx;
}

+ (VerbalExpressions *)expressions
{
    return VerEx();
}

VerbalExpressions *VerEx()
{
    return [[VerbalExpressions alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.prefixes = @"";
        self.source = @"";
        self.suffixes = @"";
        self.pattern = @"";
    }
    
    return self;
}

- (VerbalExpressions *(^)(BOOL))startOfLine
{
    return ^VerbalExpressions *(BOOL enable) {
        self.prefixes = enable ? @"^" : @"";
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(BOOL))endOfLine
{
    return ^VerbalExpressions *(BOOL enable) {
        self.suffixes = enable ? @"$" : @"";
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))find
{
    return ^VerbalExpressions *(NSString *value) {
        return self.then(value);
    };
}

- (VerbalExpressions *(^)(NSString *))then
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:%@)", value]);
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))maybe
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:%@)?", value]);
        return self;
    };
}

- (VerbalExpressions *(^)())anything
{
    return ^VerbalExpressions *() {
        self.add(@"(?:.*)");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))anythingBut
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:[^%@]*)", value]);
        return self;
    };
}

- (VerbalExpressions *(^)())something
{
    return ^VerbalExpressions *() {
        self.add(@"(?:.+)");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))somethingBut
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"(?:[^%@]+)", value]);
        return self;
    };
}

- (NSString *(^)(NSString *, NSString *))replace
{
    return ^NSString *(NSString *source, NSString *value) {
        self.add(@"");
        return [self.regex stringByReplacingMatchesInString:source options:kNilOptions range:NSMakeRange(0, source.length) withTemplate:value];
    };
}

- (VerbalExpressions *(^)())lineBreak
{
    return ^VerbalExpressions *() {
        self.add(@"(?:\\n|(?:\\r\\n))");
        return self;
    };
}

- (VerbalExpressions *(^)())br
{
    return ^VerbalExpressions *() {
        self.lineBreak();
        return self;
    };
}

- (VerbalExpressions *(^)())tab
{
    return ^VerbalExpressions *() {
        self.add(@"\\t");
        return self;
    };
}

- (VerbalExpressions *(^)())word
{
    return ^VerbalExpressions *() {
        self.add(@"\\w+");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))anyOf
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        self.add([NSString stringWithFormat:@"[%@]", value]);
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))any
{
    return ^VerbalExpressions *(NSString *value) {
        self.anyOf(value);
        return self;
    };
}

- (VerbalExpressions *(^)(NSArray *))range
{
    return ^VerbalExpressions *(NSArray *args) {
        NSString *value = @"[";
        for (NSInteger fromIndex = 0; fromIndex < args.count; fromIndex += 2) {
            NSInteger toIndex = fromIndex + 1;
            if (args.count <= toIndex) {
                break;
            }
            
            NSString *from = [self sanitize:args[fromIndex]];
            NSString *to = [self sanitize:args[toIndex]];
            value = [value stringByAppendingFormat:@"%@-%@", from, to];
        }
        
        value = [value stringByAppendingString:@"]"];
        
        self.add(value);
        return self;
    };
}

- (VerbalExpressions *(^)(BOOL))withAnyCase
{
    return ^VerbalExpressions *(BOOL enable) {
        if (enable) {
            self.addModifier('i');
        } else {
            self.removeModifier('i');
        }
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(BOOL))searchOneLine
{
    return ^VerbalExpressions *(BOOL enable) {
        if (enable) {
            self.removeModifier('m');
        } else {
            self.addModifier('m');
        }
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))multiple
{
    return ^VerbalExpressions *(NSString *value) {
        value = [self sanitize:value];
        switch ([value characterAtIndex:0]) {
            case '*':
            case '+':
                break;
            default:
                value = [value stringByAppendingString:@"+"];
        }
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(NSString *))or
{
    return ^VerbalExpressions *(NSString *value) {
        if ([self.prefixes rangeOfString:@"("].location == NSNotFound) {
            self.prefixes = [self.prefixes stringByAppendingString:@"(?:"];
        }
        if ([self.suffixes rangeOfString:@")"].location == NSNotFound) {
            self.suffixes = [self.suffixes stringByAppendingString:@")"];
        }
        self.add(@")|(?:");
        if (value) {
            self.then(value);
        }
        return self;
    };
}

- (VerbalExpressions *(^)())beginCapture
{
    return ^VerbalExpressions *() {
        self.suffixes = [self.suffixes stringByAppendingString:@")"];
        self.add(@"(");
        return self;
    };
}

- (VerbalExpressions *(^)())endCapture
{
    return ^VerbalExpressions *() {
        self.suffixes = [self.suffixes substringToIndex:self.suffixes.length - 1];
        self.add(@")");
        return self;
    };
}

- (BOOL(^)(NSString *))test
{
    return ^BOOL (NSString *toTest) {
        self.add(@"");
        
        NSRegularExpression *regex = self.regularExpression;
        NSUInteger matches = [regex numberOfMatchesInString:toTest options:kNilOptions range:NSMakeRange(0, toTest.length)];
        
        return matches > 0;
    };
}

- (NSRegularExpression *)regularExpression
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.pattern
                                                                           options:self.modifiers
                                                                             error:&error];
    if (error) {
        return nil;
    }
    
    return regex;
}

- (NSRegularExpression *)regex
{
    return self.regularExpression;
}

- (NSString *)description
{
    self.add(@"");
    return self.regularExpression.pattern;
}

#pragma mark praivate methods

- (NSString *)sanitize:(NSString *)value
{
    if (!value) {
        return nil;
    }
    return [NSRegularExpression escapedPatternForString:value];
}

- (VerbalExpressions *(^)(NSString *))add
{
    return ^VerbalExpressions *(NSString *value) {
        self.source = self.source ? [self.source stringByAppendingString:value] : value;
        if (self.source) {
            self.pattern = [NSString stringWithFormat:@"%@%@%@", self.prefixes, self.source, self.suffixes];
        }
        
        return self;
    };
}

- (VerbalExpressions *(^)(unichar))addModifier
{
    return ^VerbalExpressions *(unichar modifier) {
        switch (modifier) {
            case 'd': // UREGEX_UNIX_LINES
                self.modifiers |= NSRegularExpressionUseUnixLineSeparators;
                break;
            case 'i': // UREGEX_CASE_INSENSITIVE
                self.modifiers |= NSRegularExpressionCaseInsensitive;
                break;
            case 'x': // UREGEX_COMMENTS
                self.modifiers |= NSRegularExpressionAllowCommentsAndWhitespace;
                break;
            case 'm': // UREGEX_MULTILINE
                self.modifiers |= NSRegularExpressionAnchorsMatchLines;
                break;
            case 's': // UREGEX_DOTALL
                self.modifiers |= NSRegularExpressionDotMatchesLineSeparators;
                break;
            case 'u': // UREGEX_UWORD
                self.modifiers |= NSRegularExpressionUseUnicodeWordBoundaries;
                break;
            case 'U': // UREGEX_LITERAL
                self.modifiers |= NSRegularExpressionIgnoreMetacharacters;
                break;
            default:
                break;
        }
        
        self.add(@"");
        return self;
    };
}

- (VerbalExpressions *(^)(unichar))removeModifier
{
    return ^VerbalExpressions *(unichar modifier) {
        switch (modifier) {
            case 'd': // UREGEX_UNIX_LINES
                self.modifiers ^= NSRegularExpressionUseUnixLineSeparators;
                break;
            case 'i': // UREGEX_CASE_INSENSITIVE
                self.modifiers ^= NSRegularExpressionCaseInsensitive;
                break;
            case 'x': // UREGEX_COMMENTS
                self.modifiers ^= NSRegularExpressionAllowCommentsAndWhitespace;
                break;
            case 'm': // UREGEX_MULTILINE
                self.modifiers ^= NSRegularExpressionAnchorsMatchLines;
                break;
            case 's': // UREGEX_DOTALL
                self.modifiers ^= NSRegularExpressionDotMatchesLineSeparators;
                break;
            case 'u': // UREGEX_UWORD
                self.modifiers ^= NSRegularExpressionUseUnicodeWordBoundaries;
                break;
            case 'U': // UREGEX_LITERAL
                self.modifiers ^= NSRegularExpressionIgnoreMetacharacters;
                break;
            default:
                break;
        }
        
        self.add(@"");
        return self;
    };
}

@end
