//
//  MACommonManagerBase+private.m
//  MatesAccounting
//
//  Created by Lee on 14-2-26.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MACommonManagerBase+private.h"

@implementation MACommonManagerBase (private)

- (void)listenersForKey:(NSString *)key withBlock:(void(^)(id listener))block
{
    NSMutableSet *listenerSet = [_listeners objectForKey:key];
    for (id listener in listenerSet) {
        EXECUTE_BLOCK_SAFELY(block, listener);
    }
}

- (BOOL)listener:(id)listener isAdd:(BOOL)isAdd
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    BOOL result = NO;

    SEL selector;
    if (isAdd) {
        selector = @selector(addObject:);
    } else {
        selector = @selector(removeObject:);
    }

    for (NSString *key in [_listenerKeyToSelector allKeys]) {
        NSString *selectorName = [_listenerKeyToSelector objectForKey:key];
        if ([listener respondsToSelector:NSSelectorFromString(selectorName)]) {
            result = YES;
            [[_listeners objectForKey:key] performSelector:selector withObject:listener];
        }
    }
#pragma clang diagnostic pop
    return result;
}

@end