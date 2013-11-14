//
//  RMemberToGroup.h
//  MatesAccounting
//
//  Created by Lee on 13-11-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGroup, MMember;

@interface RMemberToGroup : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) MMember *member;
@property (nonatomic, retain) MGroup *group;

@end
