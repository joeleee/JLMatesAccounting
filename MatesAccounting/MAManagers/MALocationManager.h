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

+ (MALocationManager *)sharedManager;

- (BOOL)locationByExpirationMinute:(double)minute
                               key:(NSString *)key
                      onCompletion:(MALocationCompletionBlock)completionBlock
                          onFailed:(MALocationFailedBlock)failedBlock;

- (void)stopLocationWithKey:(NSString *)key;

@end