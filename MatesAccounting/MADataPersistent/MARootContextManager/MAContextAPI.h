//
//  MAContextAPI.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MADataPersistentProtocols.h"

@interface MAContextAPI : NSObject <MAContextProtocol>

+ (MAContextAPI *)sharedAPI;

@end