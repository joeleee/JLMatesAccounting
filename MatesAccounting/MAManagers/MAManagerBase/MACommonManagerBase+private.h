//
//  MACommonManagerBase+private.h
//  MatesAccounting
//
//  Created by Lee on 14-2-26.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MACommonManagerBase.h"

@interface MACommonManagerBase (private)

- (void)listenersForKey:(NSString *)key withBlock:(void(^)(id listener))block;

- (BOOL)listener:(id)listener isAdd:(BOOL)isAdd;

@end