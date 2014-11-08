//
//  RMemberToAccount.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount, MFriend;

@interface RMemberToAccount : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDecimalNumber * fee;
@property (nonatomic, retain) MAccount *account;
@property (nonatomic, retain) MFriend *member;

@end
