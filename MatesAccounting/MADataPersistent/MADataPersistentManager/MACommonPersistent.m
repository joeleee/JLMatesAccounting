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

+ (NSArray *)fetchObjectsWithRequest:(NSFetchRequest *)request
{
    MA_QUICK_ASSERT(request, @"Assert request == nil");
    if (!request) {
        return nil;
    }

    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSError *error = nil;
    NSArray *result = [moContext executeFetchRequest:request error:&error];

    return result;
}

+ (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
{
    MA_QUICK_ASSERT(0 < entityName.length, @"Assert request == nil");
    if (0 >= entityName.length) {
        return nil;
    }

    NSManagedObjectContext *moContext = [[MAContextAPI sharedAPI] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSError *error = nil;
    NSArray *result = [moContext executeFetchRequest:fetchRequest error:&error];

    return result;
}

@end