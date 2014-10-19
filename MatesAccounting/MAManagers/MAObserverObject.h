//
//  MAObserverObject.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-29.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


#define MA_START_ENUMERATION_OBSERVERS(observers, observerObject, selector) \
    NSMutableArray *_observers = observers;\
    NSMutableArray *invalidObservers = [NSMutableArray array];\
    for (MAObserverObject *_observerObject in observers) {\
        observerObject = _observerObject;\
        if (!observerObject.observer) {\
            [invalidObservers addObject:observerObject];\
        } else if ([observerObject.observer respondsToSelector:selector])

#define MA_END_ENUMERATION_OBSERVERS \
    }\
    [_observers removeObjectsInArray:invalidObservers]


@interface MAObserverObject : NSObject

@property (nonatomic, weak) id observer;
@property (nonatomic, readonly, copy) NSString *observerClassName;

+ (instancetype)observerObjectWith:(id)observer;

@end