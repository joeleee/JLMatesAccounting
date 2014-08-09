//
//  MPlace.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-9.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount;

@interface MPlace : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * merchantName;
@property (nonatomic, retain) NSNumber * placeID;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSSet *account;
@end

@interface MPlace (CoreDataGeneratedAccessors)

- (void)addAccountObject:(MAccount *)value;
- (void)removeAccountObject:(MAccount *)value;
- (void)addAccount:(NSSet *)values;
- (void)removeAccount:(NSSet *)values;

@end
