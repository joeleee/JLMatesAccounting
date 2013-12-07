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

@protocol protocol1 <NSObject>

@end

@protocol protocol2 <protocol1>

@end

@interface testclass : NSObject <protocol1>

@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSNumber *n;
@property (nonatomic, assign) NSInteger i;

@end

@implementation testclass

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MAAppDelegate class]));
    }


#pragma mark test object key-value-coding
    testclass *c1 = [[testclass alloc] init];
    testclass *c2 = [[testclass alloc] init];
    // NSDictionary *d1 = @{@"s":@"123", @"n":@10};
    c1.s = @"123";
    c2.s = @"123";
    c1.n = @10;
    c2.n = @10;

    id i = [c1 valueForKey:@"i"];
    NSLog(@"%@", [i description]);
    [c1 setValue:@"" forKey:@"i"];

    // BOOL b1 = [[d1 valueForKey:@"s"] isEqual:[c2 valueForKey:@"s"]];
    // BOOL b2 = [c1 validateValue:nil forKey:@"s" error:nil];
    // NSLog(@"%d", b1);
    // NSLog(@"%d", b2);
    
    return 0;

#pragma mark test date
    NSDate *date = [NSDate date];
    date = [NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970] - (24 * 60 * 60)];
    NSLog(@"%f \n %@ \n %@", [date timeIntervalSince1970], [NSDate date], date);
    return 0;

#pragma mark test date
    date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    NSUInteger dateKey = [components year] * 10000 + [components month] * 100 + [components day];
    NSLog(@"date : %@ %d-%d-%d %d",
          date,
          [components year],
          [components month],
          [components day],
          dateKey
          );
    return 0;

#pragma mark test protocol
    testclass *protocolClass = [[testclass alloc] init];
    BOOL isConforms = [protocolClass conformsToProtocol:@protocol(protocol1)];
    NSLog(@"isConforms : %d", isConforms);
    return 0;

#pragma mark test dictionary key-value-coding
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"testValue" forKey:@"testKey"];
    NSLog(@"%@", dict);
    return 0;
}