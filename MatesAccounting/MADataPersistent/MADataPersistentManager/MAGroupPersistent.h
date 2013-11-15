//
//  MAGroupPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGroup;

@interface MAGroupPersistent : NSObject

- (MGroup *)createGroup;

- (BOOL)deleteGroup:(MGroup *)group;

- (NSArray *)fetchAccount:(NSFetchRequest *)request;

@end