//
//  MAContextAPI.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAContextAPI : NSObject

+ (MAContextAPI *)sharedAPI;

- (BOOL)saveContextData;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

@end