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
#import <objc/runtime.h>

@protocol protocol1 <NSObject>

@end

@protocol protocol2 <protocol1>

@end

@interface testclass : NSObject <protocol1>

@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSNumber *n;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, retain) NSDate *nd;
@property (nonatomic, retain) id d;
//@property (nonatomic, assign) NSInteger ni;
//@property (nonatomic, assign) double d;
//@property (nonatomic, assign) CGFloat cf;

@end

@implementation testclass

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MAAppDelegate class]));
    }


#pragma mark test NSString
    NSString *ts1 = @"http://fmn.rrimg.com/fmn063/gouwu/20131015/1130/original_txLI_557d00000079118e.Gif";
    NSString *ts2 = @"/p/m3w150h150q85lt_";

    if ([[[ts1 substringFromIndex:ts1.length - 4] lowercaseString] isEqualToString:@".gif"]) {
        return 0;
    }

    NSRange range = [ts1 rangeOfString:@"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    // NSLog(@"location:%u, length:%u", range.location, range.length);
    // NSRange range;
    // range.location = 0;
    // range.length = ts1.length;
    ts2 = [ts1 stringByReplacingOccurrencesOfString:@"/" withString:ts2 options:NSBackwardsSearch range:range];
    NSLog(@"\nts1:%@\nts2:%@", ts1, ts2);

    return 0;

#pragma mark test time coding
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    return 0;
    testclass *r1 = [[testclass alloc] init];
    unsigned int propsCount;
    objc_property_t *propList = class_copyPropertyList([r1 class], &propsCount);

    for (int i = 0; i < propsCount; i++) {
        objc_property_t oneProp = propList[i];
        NSString *attrs = [NSString stringWithUTF8String:property_getAttributes(oneProp)];
        NSArray *attrParts = [attrs componentsSeparatedByString:@","];
        NSString *stringName = [[attrParts objectAtIndex:0] substringFromIndex:1];
        NSLog(@"%@", stringName);
    }

    if (propList)
        free(propList);
    return 0;

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