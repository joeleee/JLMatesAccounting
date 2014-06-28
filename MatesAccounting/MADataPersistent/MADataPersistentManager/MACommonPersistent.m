//
//  MACommonPersistent.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MACommonPersistent.h"

#import "MAContextAPI.h"

@implementation MACommonPersistent

+ (id)createObject:(NSString *)entityName
{
    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSManagedObjectModel   *moModel = [[MAContextAPI sharedAPI] managedObjectModel];
    NSEntityDescription    *entity = [[moModel entitiesByName] objectForKey:entityName];

    id object = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:moContext];

    MA_QUICK_ASSERT(object, @"Assert object == nil");

    return object;
}

+ (BOOL)deleteObject:(id)object
{
    BOOL isSucceed = NO;

    if (!object) {
        return isSucceed;
    }

    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    [moContext deleteObject:object];
    isSucceed = [[MAContextAPI sharedAPI] saveContextData];

    return isSucceed;
}

+ (NSArray *)fetchObjects:(NSFetchRequest *)request entityName:(NSString *)entityName
{
    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];

    if (entityName) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moContext];
        MA_QUICK_ASSERT(entityDescription, @"Assert object == nil");
        [request setEntity:entityDescription];
    }

    NSError *error = nil;
    NSArray *result = [moContext executeFetchRequest:request error:&error];

    return result;
}

@end