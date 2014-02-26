//
//  MACommonManagerBase.h
//  MatesAccounting
//
//  Created by Lee on 14-2-25.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

// TODO: 暂时废用

#import <Foundation/Foundation.h>

@interface MACommonManagerBase : NSObject
{
    @protected
    NSDictionary *_listeners;
    NSDictionary *_listenerKeyToSelector;
}

+ (instancetype)sharedManager;

@end