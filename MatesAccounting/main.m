//
//  main.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAAppDelegate.h"
#import "MAccount+expand.h"

@interface testclass : NSObject

@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSNumber *n;

@end

@implementation testclass

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MAAppDelegate class]));
    }

    testclass *c1 = [[testclass alloc] init];
    testclass *c2 = [[testclass alloc] init];
    // NSDictionary *d1 = @{@"s":@"123", @"n":@10};
    c1.s = @"123";
    c2.s = @"123";
    c1.n = @10;
    c2.n = @10;

    // BOOL b1 = [[d1 valueForKey:@"s"] isEqual:[c2 valueForKey:@"s"]];
    BOOL b2 = [c1 validateValue:nil forKey:@"s" error:nil];

    // NSLog(@"%d", b1);
    NSLog(@"%d", b2);

    return 0;
}