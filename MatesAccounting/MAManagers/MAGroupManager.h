//
//  MAGroupManager.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGroup;

@interface MAGroupManager : NSObject

+ (MAGroupManager *)sharedManager;

- (MGroup *)currentGroup;

@end