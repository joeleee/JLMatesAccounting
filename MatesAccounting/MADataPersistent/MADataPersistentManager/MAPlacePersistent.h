//
//  MAPlacePersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-19.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MPlace;

@interface MAPlacePersistent : NSObject

+ (MAPlacePersistent *)instance;

- (MPlace *)createPlaceWithLocation:(CLLocation *)location name:(NSString *)name;

- (BOOL)deletePlace:(MPlace *)place;

- (NSArray *)fetchPlaces:(NSFetchRequest *)request;

@end