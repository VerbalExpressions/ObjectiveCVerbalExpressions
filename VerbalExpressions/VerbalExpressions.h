//
//  VerbalExpressions.h
//  VerbalExpressions
//
//  Created by kishikawa katsumi on 2013/08/11.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbalExpressions : NSObject

@property (nonatomic, copy) VerbalExpressions *(^startOfLine)(BOOL enable);
@property (nonatomic, copy) VerbalExpressions *(^endOfLine)(BOOL enable);
@property (nonatomic, copy) VerbalExpressions *(^find)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^then)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^maybe)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^anything)();
@property (nonatomic, copy) VerbalExpressions *(^anythingBut)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^something)();
@property (nonatomic, copy) VerbalExpressions *(^somethingBut)(NSString *value);
@property (nonatomic, copy) NSString *(^replace)(NSString *source, NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^lineBreak)();
@property (nonatomic, copy) VerbalExpressions *(^br)();
@property (nonatomic, copy) VerbalExpressions *(^tab)();
@property (nonatomic, copy) VerbalExpressions *(^word)();
@property (nonatomic, copy) VerbalExpressions *(^anyOf)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^any)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^range)(NSArray *args);
@property (nonatomic, copy) VerbalExpressions *(^withAnyCase)(BOOL enable);
@property (nonatomic, copy) VerbalExpressions *(^searchOneLine)(BOOL enable);
@property (nonatomic, copy) VerbalExpressions *(^multiple)(NSString *value);
@property (nonatomic, copy) VerbalExpressions *(^or)(NSString *value);
@property (nonatomic, copy) BOOL (^test)(NSString *toTest);

@property (nonatomic, readonly) NSRegularExpression *regularExpression;

+ (VerbalExpressions *)instantiate:(void (^)(VerbalExpressions *ve))block;

@end
