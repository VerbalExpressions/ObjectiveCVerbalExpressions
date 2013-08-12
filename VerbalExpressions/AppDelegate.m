//
//  AppDelegate.m
//  VerbalExpressions
//
//  Created by kishikawa katsumi on 2013/08/12.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "AppDelegate.h"
#import "VerbalExpressions.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     * Testing if we have a valid URL
     */
    // Create an example of how to test for correctly formed URLs
    VerbalExpressions *verEx = [VerbalExpressions instantiate:^(VerbalExpressions *ve) {
        ve
        .startOfLine(YES)
        .then(@"http")
        .maybe(@"s")
        .then(@"://")
        .maybe(@"www")
        .anythingBut(@" ")
        .endOfLine(YES);
    }];
    
    // Create an example URL
    NSString *testMe = @"https://www.google.com";
    
    // Use test() method
    if (verEx.test(testMe)) {
        NSLog(@"%@", @"We have a correct URL"); // This output will fire
    } else {
        NSLog(@"%@", @"The URL is incorrect");
    }
    
    NSLog(@"%@", verEx); // Ouputs the actual expression used: "^(http)(s)?(:\/\/)(www)?([^ ]*)$"
    
    /*
     * Replacing strings
     */
    // Create a test string
    NSString *replaceMe = @"Replace bird with a duck";
    
    // Create an expression that seeks for word "bird"
    VerbalExpressions *expression = [VerbalExpressions instantiate:^(VerbalExpressions *ve) {
        ve.find(@"bird");
    }];
    
    // Execute the expression like a normal RegExp object
    NSString *result1 = expression.replace(replaceMe, @"duck" );
    
    NSLog(@"%@", result1); // Outputs "Replace duck with a duck"
    
    /*
     * Shorthand for string replace:
     */
    NSString *result2 = [VerbalExpressions instantiate:^(VerbalExpressions *ve) {
        ve.find(@"red");
    }].replace(@"We have a red house", @"blue");
    
    NSLog(@"%@", result2); // Outputs "We have a blue house"
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
