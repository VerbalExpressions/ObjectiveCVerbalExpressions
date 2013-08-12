//
//  OCVerbalExpression.m
//  OCVerbalExpression
//
//  Created by Mathew Cruz on 8/12/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "OCVerbalExpression.h"

@interface OCVerbalExpression ()
@property (nonatomic, strong) NSString *prefixes;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *suffixes;
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic) NSRegularExpressionOptions modifiers;
@end

@implementation OCVerbalExpression

- (instancetype)init
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

- (OCVerbalExpression *)startOfLine:(BOOL)enable
{
    self.prefixes = enable ? @"^" : @"";
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)endOfLine:(BOOL)enable
{
    self.suffixes = enable ? @"$" : @"";
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)find:(NSString *)value
{
    return [self then:value];
}

- (OCVerbalExpression *)then:(NSString *)value
{
    value = [self sanitize:value];
    [self add:[NSString stringWithFormat:@"(%@)", value]];
    return self;
}

- (OCVerbalExpression *)maybe:(NSString *)value
{
    value = [self sanitize:value];
    [self add:[NSString stringWithFormat:@"(%@)?", value]];
    return self;
}

- (OCVerbalExpression *)anything
{
    [self add:@"(.*)"];
    return self;
}

- (OCVerbalExpression *)anythingBut:(NSString *)value
{
    value = [self sanitize:value];
    [self add:[NSString stringWithFormat:@"([^%@]*)", value]];
    return self;
}

- (OCVerbalExpression *)something
{
    [self add:@"(.+)"];
    return self;
}

- (OCVerbalExpression *)somethingBut:(NSString *)value
{
    value = [self sanitize:value];
    [self add:[NSString stringWithFormat:@"([^%@]+)", value]];
    return self;
}

- (NSString *)replaceWithSource:(NSString *)source value:(NSString *)value
{
    [self add:@""];
    return [self.regularExpression stringByReplacingMatchesInString:source options:kNilOptions range:NSMakeRange(0, source.length) withTemplate:value];
}

- (OCVerbalExpression *)lineBreak
{
    [self add:@"(\\n|(\\r\\n))"];
    return self;
}

- (OCVerbalExpression *)br
{
    [self lineBreak];
    return self;
}

- (OCVerbalExpression *)tab
{
    [self add:@"\\t"];
    return self;
}

- (OCVerbalExpression *)word
{
    [self add:@"\\w+"];
    return self;
}

- (OCVerbalExpression *)anyOf:(NSString *)value
{
    value = [self sanitize:value];
    [self add:[NSString stringWithFormat:@"[%@]", value]];
    return self;
}

- (OCVerbalExpression *)any:(NSString *)value
{
    [self anyOf:value];
    return self;
}

- (OCVerbalExpression *)range:(NSArray *)args
{
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
    
    [self add:value];
    return self;
}

- (OCVerbalExpression *)withAnyCase:(BOOL)enable
{
    if (enable) {
        [self addModifier:'i'];
    } else {
        [self removeModifier:'i'];
    }
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)searchOneLine:(BOOL)enable
{
    if (enable) {
        [self removeModifier:'m'];
    } else {
        [self addModifier:'m'];
    }
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)multiple:(NSString *)value
{
    value = [self sanitize:value];
    switch ([value characterAtIndex:0]) {
        case '*':
        case '+':
            break;
        default:
            value = [value stringByAppendingString:@"+"];
    }
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)or:(NSString *)value
{
    if ([self.prefixes rangeOfString:@"("].location == NSNotFound) {
        self.prefixes = [self.prefixes stringByAppendingString:@"("];
    }
    if ([self.suffixes rangeOfString:@")"].location == NSNotFound) {
        self.suffixes = [self.suffixes stringByAppendingString:@")"];
    }
    [self add:@")|("];
    if (value) {
        [self then:value];
    }
    return self;
}

- (BOOL)test:(NSString *)toTest
{
    [self add:@""];
    
    NSRegularExpression *regex = self.regularExpression;
    NSUInteger matches = [regex numberOfMatchesInString:toTest options:kNilOptions range:NSMakeRange(0, toTest.length)];
    
    return matches > 0;
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

- (NSString *)description
{
    [self add:@""];
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

- (OCVerbalExpression *)add:(NSString *)value
{
    self.source = self.source ? [self.source stringByAppendingString:value] : value;
    if (self.source) {
        self.pattern = [NSString stringWithFormat:@"%@%@%@", self.prefixes, self.source, self.suffixes];
    }
    
    return self;
}

- (OCVerbalExpression *)addModifier:(unichar)modifier
{
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
    
    [self add:@""];
    return self;
}

- (OCVerbalExpression *)removeModifier:(unichar)modifier
{
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
    
    [self add:@""];
    return self;
}
@end
