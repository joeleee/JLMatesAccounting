//
//  MADataPersistentAPI.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentAPI.h"

#import "MAContextAPI.h"

@implementation MADataPersistentAPI

+ (MADataPersistentAPI *)sharedAPI
{
    static MADataPersistentAPI *sharedInstance;
    static dispatch_once_t      onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)saveAllContext
{
    return [[MAContextAPI sharedAPI] saveContextData];
}

@end