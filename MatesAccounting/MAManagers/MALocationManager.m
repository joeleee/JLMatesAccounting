//
//  MALocationManager.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-20.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MALocationManager.h"

NSInteger const MALocationTimeOutErrorCode = 10000;
double const kLocationTimeOutSeconds = 10.0f;
NSString * const kCachedLocationKey = @"kCachedLocationKey";

NSString * const kCallBackHandlersCompletionBlockKey = @"kCallBackHandlersCompletionBlockKey";
NSString * const kCallBackHandlersFailedBlockKey = @"kCallBackHandlersFailedBlockKey";

@interface MALocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *cachedLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableDictionary *callBackHandlerDict;
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
        self.cachedLocation = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kCachedLocationKey]];
        self.callBackHandlerDict = [NSMutableDictionary dictionary];
        self.isLocating = NO;
    }

    return self;
}

- (BOOL)locationByExpirationMinute:(double)minute
                               key:(NSString *)key
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
        if (!key) {
            key = [@([[NSDate date] timeIntervalSince1970]) stringValue];
        }
        self.callBackHandlerDict[key] = @{kCallBackHandlersCompletionBlockKey: [completionBlock copy], kCallBackHandlersFailedBlockKey: [failedBlock copy]};
        if (!self.isLocating) {
            self.cachedLocation = nil;
            self.isLocating = YES;
            [self.locationManager startUpdatingLocation];
            [self performSelector:@selector(stopLocationWithError:) withObject:[NSError errorWithDomain:@"Locating is time out!" code:MALocationTimeOutErrorCode userInfo:nil] afterDelay:kLocationTimeOutSeconds];
        }
    } else {
        MA_INVOKE_BLOCK_SAFELY(completionBlock, self.cachedLocation);
    }
    return YES;
}

- (void)stopLocationWithKey:(NSString *)key
{
    if (!key || ![self.callBackHandlerDict objectForKey:key]) {
        return;
    }

    [self.callBackHandlerDict removeObjectForKey:key];
    if (0 >= [self.callBackHandlerDict allValues].count) {
        [self stopLocationWithError:nil];
    }
}

#pragma mark private API
- (void)stopLocationWithError:(NSError *)error
{
    if (!self.isLocating) {
        return;
    }

    self.isLocating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopLocationWithError:) object:nil];
    [self.locationManager stopUpdatingLocation];

    for (NSDictionary *callBackHandlerDict in [self.callBackHandlerDict allValues]) {
        if (error) {
            MALocationFailedBlock failedBlock = callBackHandlerDict[kCallBackHandlersFailedBlockKey];
            MA_INVOKE_BLOCK_SAFELY(failedBlock, error);
        } else {
            MALocationCompletionBlock completionBlock = callBackHandlerDict[kCallBackHandlersCompletionBlockKey];
            MA_INVOKE_BLOCK_SAFELY(completionBlock, self.cachedLocation);
        }
    }
    [self.callBackHandlerDict removeAllObjects];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *bestLocation = self.cachedLocation;
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 0 || -[location.timestamp timeIntervalSinceNow] > 8.0) {
            continue;
        }
        if (!bestLocation || location.horizontalAccuracy <= self.cachedLocation.horizontalAccuracy) {
            bestLocation = location;
        }
    }

    if (bestLocation && bestLocation != self.cachedLocation && bestLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
        self.cachedLocation = bestLocation;
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

- (void)setCachedLocation:(CLLocation *)cachedLocation
{
    if (_cachedLocation == cachedLocation) {
        return;
    }

    _cachedLocation = cachedLocation;
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_cachedLocation] forKey:kCachedLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end