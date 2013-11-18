//
//  MPlace.h
//  MatesAccounting
//
//  Created by Lee on 13-11-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount;

@interface MPlace : NSManagedObject

@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * merchantName;
@property (nonatomic, retain) NSOrderedSet *account;
@end

@interface MPlace (CoreDataGeneratedAccessors)

- (void)insertObject:(MAccount *)value inAccountAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAccountAtIndex:(NSUInteger)idx;
- (void)insertAccount:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAccountAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAccountAtIndex:(NSUInteger)idx withObject:(MAccount *)value;
- (void)replaceAccountAtIndexes:(NSIndexSet *)indexes withAccount:(NSArray *)values;
- (void)addAccountObject:(MAccount *)value;
- (void)removeAccountObject:(MAccount *)value;
- (void)addAccount:(NSOrderedSet *)values;
- (void)removeAccount:(NSOrderedSet *)values;
@end
