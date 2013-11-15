//
//  MADataPersistentAPI.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MADataPersistentProtocols.h"

@interface MADataPersistentAPI : NSObject

+ (MADataPersistentAPI *)sharedAPI;

- (BOOL)saveAllContext;

@end