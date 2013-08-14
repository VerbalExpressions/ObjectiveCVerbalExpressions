//
//  VerbalExpressions.h
//  VerbalExpressions
//
//  Created by kishikawa katsumi on 2013/08/11.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbalExpressions : NSObject

@property (nonatomic, readonly) VerbalExpressions *(^startOfLine)(BOOL enable);
@property (nonatomic, readonly) VerbalExpressions *(^endOfLine)(BOOL enable);
@property (nonatomic, readonly) VerbalExpressions *(^find)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^then)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^maybe)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^anything)();
@property (nonatomic, readonly) VerbalExpressions *(^anythingBut)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^something)();
@property (nonatomic, readonly) VerbalExpressions *(^somethingBut)(NSString *value);
@property (nonatomic, readonly) NSString *(^replace)(NSString *source, NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^lineBreak)();
@property (nonatomic, readonly) VerbalExpressions *(^br)();
@property (nonatomic, readonly) VerbalExpressions *(^tab)();
@property (nonatomic, readonly) VerbalExpressions *(^word)();
@property (nonatomic, readonly) VerbalExpressions *(^anyOf)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^any)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^range)(NSArray *args);
@property (nonatomic, readonly) VerbalExpressions *(^withAnyCase)(BOOL enable);
@property (nonatomic, readonly) VerbalExpressions *(^searchOneLine)(BOOL enable);
@property (nonatomic, readonly) VerbalExpressions *(^multiple)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^or)(NSString *value);
@property (nonatomic, readonly) VerbalExpressions *(^beginCapture)();
@property (nonatomic, readonly) VerbalExpressions *(^endCapture)();

@property (nonatomic, readonly) BOOL (^test)(NSString *toTest);

@property (nonatomic, readonly) NSRegularExpression *regularExpression;
@property (nonatomic, readonly) NSRegularExpression *regex;

+ (VerbalExpressions *)instantiate:(void (^)(VerbalExpressions *ve))block;
+ (VerbalExpressions *)expressions;
extern VerbalExpressions *VerEx();

@end
