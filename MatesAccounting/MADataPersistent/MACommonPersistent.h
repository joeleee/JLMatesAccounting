//
//  MACommonPersistent.h
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MACommonPersistent : NSObject

+ (id)createObject:(NSString *)entityName;

+ (BOOL)deleteObject:(id)object;

+ (NSArray *)fetchObjectsWithRequest:(NSFetchRequest *)request;

+ (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName;

@end