//
//  MACellProtocols.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MACellReuseProtocol <NSObject>

@required
- (void)reuseCellWithData:(id)data;
+ (CGFloat)cellHeight:(id)data;
+ (NSString *)reuseIdentifier;

@end