//
//  AppDelegate.m
//  VerbalExpressions
//
//  Created by kishikawa katsumi on 2013/08/12.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "AppDelegate.h"
#import "OCVerbalExpression.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     * Testing if we have a valid URL
     */
    // Create an example of how to test for correctly formed URLs
    
    OCVerbalExpression *expressions = [[OCVerbalExpression alloc] init];
    [expressions startOfLine:YES];
    [expressions then:@"http"];
    [expressions maybe:@"s"];
    [expressions then:@"://"];
    [expressions maybe:@"www"];
    [expressions anythingBut:@" "];
    [expressions endOfLine:YES];
    // Create an example URL
    NSString *testMe = @"https://www.google.com";
    
    // Use test: method
    
    if ([expressions test:testMe]) {
        NSLog(@"%@", @"We have a correct URL"); // This output will fire
    } else {
        NSLog(@"%@", @"The URL is incorrect");
    }
    
    NSLog(@"%@", expressions); // Ouputs the actual expression used: "^(http)(s)?(:\/\/)(www)?([^ ]*)$"
    
    /*
     * Replacing strings
     */
    // Create a test string
    NSString *replaceMe = @"Replace bird with a duck";
    
    // Create an expression that seeks for word "bird"
    
    OCVerbalExpression *expressions1 = [[OCVerbalExpression alloc] init];
    [expressions1 find:@"bird"];
    
    // Execute the expression like a normal RegExp object
    NSString *result1 = [expressions1 replaceWithSource:replaceMe value:@"duck"]; //expression.replace(replaceMe, @"duck" );
    
    NSLog(@"%@", result1); // Outputs "Replace duck with a duck"
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
