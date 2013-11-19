//
//  MADataPersistentSearchManager.m
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentSearchManager.h"

@implementation MADataPersistentSearchManager

+ (MADataPersistentSearchManager *)sharedManager
{
    static MADataPersistentSearchManager *sharedInstance;
    static dispatch_once_t               onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
