//
//  MPlace.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-21.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount;

@interface MPlace : NSManagedObject

@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSNumber * placeID;
@property (nonatomic, retain) MAccount *account;

@end
