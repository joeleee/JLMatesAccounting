//
//  MALocationManager.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-20.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

extern NSInteger const MALocationTimeOutErrorCode;

typedef void (^ MALocationCompletionBlock) (CLLocation *location);
typedef void (^ MALocationFailedBlock)(NSError *error);

@interface MALocationManager : NSObject

@end