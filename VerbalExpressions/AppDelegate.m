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
    
    // Example where you have an HTML string where you want to take out img tags that have either no extension or a
    // pdf, doc, docx, xls, xlsx extension
    NSString *HTML = @"<div><img src=\"asd1\"></div> <div><img src=\"asd2.pdf\"></div><div><img src=\"asd3.pdf\"></div><div><img src=\"asd4.pdf\"></div><div><img src=\"asd5.pdf\"></div><div><img src=\"asd6.pdf\"></div><div><img src=\"asd7.pdf\"></div><div><img src=\"asd8.pdf\"></div><div><img src=\"asd9.pdf\"></div><div><img src=\"asd11.pdf\"></div><div><img src=\"asd111\"></div><div><img src=\"asd1111.xls\"></div><div><img src=\"asd11111.png\"></div><div><img src=\"asd222.jpg\"></div><div><img src=\"asd343.xlsx\"></div>";
    
    OCVerbalExpression *complexExpr = [OCVerbalExpression new];
    [[[[[[[complexExpr find:@"<div><img"]
                anythingBut:@">"]
                anyWhiteSpace]
                       then:@"src"]
                anyWhiteSpace]
                       then:@"="]
                anyWhiteSpace];
    
    [complexExpr then:[OCVerbalExpression orWithObjects:@[@"'", @"\""]]];
    [complexExpr anythingBut:[OCVerbalExpression orWithObjects:@[@"'", @".", @"\""]]];
    [complexExpr thenWithGroup:^{
        [complexExpr thenWithGroup:^{
            [complexExpr then:@"."];
            [complexExpr then:[OCVerbalExpression orWithObjects:@[@"pdf", @"doc", @"docx", @"xls", @"xlsx"]]];
            [complexExpr then:[OCVerbalExpression orWithObjects:@[@"'", @"\""]]];
        }];
        [complexExpr orWithGroup:^{
            [complexExpr then:@"'"];
            [complexExpr or:@"\""];
        }];
    }];
    [[[[complexExpr anyWhiteSpace] then:@">"] anyWhiteSpace] then:@"</div>"];
    

    
    NSString *result2 = [complexExpr replaceWithSource:HTML value:@""];
    
    NSLog(@"%@", result2);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
