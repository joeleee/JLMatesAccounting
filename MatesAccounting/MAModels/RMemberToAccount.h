//
//  RMemberToAccount.h
//  MatesAccounting
//
//  Created by Lee on 13-11-18.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAccount, MMember;

@interface RMemberToAccount : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) MAccount *account;
@property (nonatomic, retain) MMember *member;

@end
