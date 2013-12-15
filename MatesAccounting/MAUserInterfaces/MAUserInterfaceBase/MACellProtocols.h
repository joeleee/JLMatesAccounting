//
//  MACellProtocols.h
//  MatesAccounting
//
//  Created by Lee on 13-11-27.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MACellActionDelegate

@required
- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type;

@end

@protocol MACellReuseProtocol <NSObject>

@required
- (void)reuseCellWithData:(id)data;
+ (CGFloat)cellHeight:(id)data;
+ (NSString *)reuseIdentifier;

@optional
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, weak) id<MACellActionDelegate> actionDelegate;

@end