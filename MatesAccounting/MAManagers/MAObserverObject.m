//
//  MAObserverObject.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-29.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAObserverObject.h"

@interface MAObserverObject ()

@property (nonatomic, copy) NSString *observerClassName;

@end

@implementation MAObserverObject

+ (instancetype)observerObjectWith:(id)observer
{
  MAObserverObject *observerObject = [[MAObserverObject alloc] init];
  observerObject.observer = observer;
  return observerObject;
}

- (void)setObserver:(id)observer
{
  if (_observer == observer) {
    return;
  }

  _observer = observer;
  self.observerClassName = [observer className];
}

@end