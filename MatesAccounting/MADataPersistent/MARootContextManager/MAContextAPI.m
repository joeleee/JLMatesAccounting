//
//  MAContextAPI.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAContextAPI.h"

#import "MARootContextManager.h"

@implementation MAContextAPI

+ (MAContextAPI *)sharedAPI
{
    static MAContextAPI    *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] init];
        });
    return sharedInstance;
}

- (BOOL)saveContextData
{
    BOOL isSucceed = [[MARootContextManager sharedManager] saveContext];

    return isSucceed;
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSManagedObjectModel *model = [[MARootContextManager sharedManager] managedObjectModel];

    return model;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = [[MARootContextManager sharedManager] managedObjectContext];

    return context;
}

@end