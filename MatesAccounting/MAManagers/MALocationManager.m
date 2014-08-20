//
//  MALocationManager.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-20.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MALocationManager.h"

NSInteger const MALocationTimeOutErrorCode = 10000;
double const kLocationTimeOutSeconds = 20.0f;
NSString * const kCachedLocationKey = @"kCachedLocationKey";

NSString * const kCallBackHandlersCompletionBlockKey = @"kCallBackHandlersCompletionBlockKey";
NSString * const kCallBackHandlersFailedBlockKey = @"kCallBackHandlersFailedBlockKey";

@interface MALocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *cachedLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *callBackHandlers;
@property (nonatomic, assign) BOOL isLocating;

@end

@implementation MALocationManager

+ (MALocationManager *)sharedManager
{
    static MALocationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MALocationManager alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.cachedLocation = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedLocationKey];
        self.callBackHandlers = [NSMutableArray array];
        self.isLocating = NO;
    }

    return self;
}

- (BOOL)locationByExpirationMinute:(double)minute
                      onCompletion:(MALocationCompletionBlock)completionBlock
                          onFailed:(MALocationFailedBlock)failedBlock
{
    if (![CLLocationManager locationServicesEnabled] || kCLAuthorizationStatusDenied == [CLLocationManager authorizationStatus]) {
        return NO;
    }

    BOOL isExpired = !self.cachedLocation || (NSOrderedAscending == [(NSDate *)[self.cachedLocation.timestamp dateByAddingTimeInterval:minute * 60] compare:[NSDate date]]);
    if (isExpired) {
        completionBlock = completionBlock ? : ^(CLLocation *location){};
        failedBlock = failedBlock ? : ^(NSError *error){};
        NSDictionary *callBackHandlerDict = @{kCallBackHandlersCompletionBlockKey: [completionBlock copy], kCallBackHandlersFailedBlockKey: [failedBlock copy]};
        [self.callBackHandlers addObject:callBackHandlerDict];
        if (!self.isLocating) {
            self.isLocating = YES;
            [self.locationManager startUpdatingLocation];
            [self performSelector:@selector(stopLocationWithError:) withObject:[NSError errorWithDomain:@"Locating is time out!" code:MALocationTimeOutErrorCode userInfo:nil] afterDelay:kLocationTimeOutSeconds];
        }
    } else {
        MA_INVOKE_BLOCK_SAFELY(completionBlock, self.cachedLocation);
    }
    return YES;
}

- (void)stopLocationWithError:(NSError *)error
{
    self.isLocating = NO;
    [self.locationManager stopUpdatingLocation];

    for (NSDictionary *callBackHandlerDict in self.callBackHandlers) {
        if (error) {
            MALocationFailedBlock failedBlock = callBackHandlerDict[kCallBackHandlersFailedBlockKey];
            MA_INVOKE_BLOCK_SAFELY(failedBlock, error);
        } else {
            MALocationCompletionBlock completionBlock = callBackHandlerDict[kCallBackHandlersCompletionBlockKey];
            MA_INVOKE_BLOCK_SAFELY(completionBlock, self.cachedLocation);
        }
    }
    [self.callBackHandlers removeAllObjects];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 0 || -[location.timestamp timeIntervalSinceNow] > 15.0) {
            continue;
        }
        if (!self.cachedLocation || location.horizontalAccuracy <= self.cachedLocation.horizontalAccuracy) {
            self.cachedLocation = location;
        }
    }

    if (self.cachedLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
        [self stopLocationWithError:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopLocationWithError:error];
    }
}

#pragma mark property
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }

    return _locationManager;
}

@end