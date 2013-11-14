//
//  MADataPersistentAPI.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentAPI.h"

#import "MARootContextManager.h"

@implementation MADataPersistentAPI

+ (BOOL)saveContextData
{
    return [[MARootContextManager sharedInstance] saveContext];
}

@end