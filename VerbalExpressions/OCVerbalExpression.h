//
//  OCVerbalExpression.h
//  VerbalExpressions
//
//    The MIT License (MIT)
//
//    Copyright (c) 2013 Mathew Cruz
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface OCVerbalExpression : NSObject

@property (nonatomic, readonly) NSRegularExpression *regularExpression;

- (OCVerbalExpression *)startOfLine:(BOOL)enable;
- (OCVerbalExpression *)endOfLine:(BOOL)enable;
- (OCVerbalExpression *)find:(NSString *)value;
- (OCVerbalExpression *)then:(NSString *)value;
- (OCVerbalExpression *)thenWithGroup:(void(^)(void))valuesToGroup;
- (OCVerbalExpression *)maybe:(NSString *)value;
- (OCVerbalExpression *)anything;
- (OCVerbalExpression *)anythingBut:(NSString *)value;
- (OCVerbalExpression *)something;
- (OCVerbalExpression *)somethingBut:(NSString *)value;
- (OCVerbalExpression *)lineBreak;
- (OCVerbalExpression *)br;
- (OCVerbalExpression *)tab;
- (OCVerbalExpression *)word;
- (OCVerbalExpression *)anyWhiteSpace;
- (OCVerbalExpression *)anyOf:(NSString *)value;
- (OCVerbalExpression *)any:(NSString *)value;
- (OCVerbalExpression *)range:(NSArray *)args;
- (OCVerbalExpression *)withAnyCase:(BOOL)enable;
- (OCVerbalExpression *)searchOneLine:(BOOL)enable;
- (OCVerbalExpression *)multiple:(NSString *)value;
- (OCVerbalExpression *)or:(NSString *)value;
- (OCVerbalExpression *)orWithGroup:(void(^)(void))valuesToGroup;

+ (NSString *)orWithObjects:(NSArray *)objects;

- (BOOL)test:(NSString *)toTest;
- (NSString *)replaceWithSource:(NSString *)source value:(NSString *)value;

- (NSString *)expressionString;

@end
