ObjectiveCVerbalExpressions
=====================
[![Build Status](https://travis-ci.org/kishikawakatsumi/ObjectiveCVerbalExpressions.png?branch=master)](https://travis-ci.org/kishikawakatsumi/ObjectiveCVerbalExpressions)
[![Coverage Status](https://coveralls.io/repos/kishikawakatsumi/ObjectiveCVerbalExpressions/badge.png?branch=master)](https://coveralls.io/r/kishikawakatsumi/ObjectiveCVerbalExpressions?branch=master)

## Objective-C Regular Expressions made easy
ObjectiveCVerbalExpressions is a Objective-C library that helps to construct difficult regular expressions - ported from the awesome JavaScript [VerbalExpressions](https://github.com/jehna/VerbalExpressions).

## Examples

Here's a couple of simple examples to give an idea of how VerbalExpressions works:

### Testing if we have a valid URL

```objc
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

NSLog(@"%@", tester); // Ouputs the actual expression used: "^(http)(s)?(:Å_/Å_/)(www)?([^ ]*)$"
```

### Replacing strings

```objc
NSString *replaceMe = @"Replace bird with a duck";

// Create an expression that seeks for word "bird"
OCVerbalExpression *expressions1 = [[OCVerbalExpression alloc] init];
[expressions1 find:@"bird"];

// Execute the expression like a normal RegExp object
NSString *result = [expressions1 replaceWithSource:replaceMe value:@"duck"];

NSLog(@"%@", result); // Outputs "Replace duck with a duck"
```

### Shorthand for string replace:

```objc
NSString *result2 = [[[OCVerbalExpression new] find:@"red"] replaceWithSource:@"We have a red house" value:@"blue"];

NSLog(@"%@", result2); // Outputs "We have a blue house"
```

### Complex example:

```objc
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
NSLog(@"%@", result2); // <div><img src="asd11111.png"></div><div><img src="asd222.jpg"></div>
```

## API documentation

I haven't added much documentation to this repo yet, but you can find the documentation for the original JavaScript repo on their [wiki](https://github.com/jehna/VerbalExpressions/wiki).  Most of the methods have been ported as of v0.1.0 of the JavaScript repo.  Just be sure to use the syntax explained above rather than the dot notation :)

## Contributions
Clone the repo and fork!
Pull requests are warmly welcomed!

## Issues
 - I haven't yet ported the `stopAtFirst` method.

## Thanks!
Thank you to @jehna for coming up with the awesome original idea!
