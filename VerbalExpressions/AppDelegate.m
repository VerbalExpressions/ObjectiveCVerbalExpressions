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
    VerbalExpressions *tester = VerEx()
    .startOfLine(YES)
    .then(@"http")
    .maybe(@"s")
    .then(@"://")
    .maybe(@"www")
    .anythingBut(@" ")
    .endOfLine(YES);
    
    // Create an example URL
    NSString *testMe = @"https://www.google.com";
    
    // Use test() method
    if (tester.test(testMe)) {
        NSLog(@"%@", @"We have a correct URL"); // This output will fire
    } else {
        NSLog(@"%@", @"The URL is incorrect");
    }
    
    NSLog(@"%@", tester); // Ouputs the actual expression used: "^(http)(s)?(:\/\/)(www)?([^ ]*)$"
    
    /*
     * Replacing strings
     */
    // Create a test string
    NSString *replaceMe = @"Replace bird with a duck";
    
    // Create an expression that seeks for word "bird"
    VerbalExpressions *verEx = VerEx().find(@"bird");
    
    // Execute the expression like a normal RegExp object
    NSString *result1 = verEx.replace(replaceMe, @"duck" );
    
    NSLog(@"%@", result1); // Outputs "Replace duck with a duck"
    
    /*
     * Shorthand for string replace:
     */
    NSString *result2 = VerEx().find(@"red").replace(@"We have a red house", @"blue");
    
    NSLog(@"%@", result2); // Outputs "We have a blue house"
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
