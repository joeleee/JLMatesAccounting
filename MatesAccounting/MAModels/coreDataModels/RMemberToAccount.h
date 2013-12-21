//
//  RMemberToAccount.h
//  MatesAccounting
//
//  Created by Lee on 13-12-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount, MFriend;

@interface RMemberToAccount : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) MAccount *account;
@property (nonatomic, retain) MFriend *member;

@end
