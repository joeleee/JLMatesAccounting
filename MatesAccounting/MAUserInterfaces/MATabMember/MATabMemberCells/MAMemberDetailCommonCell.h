//
//  MAMemberDetailCell.h
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAMemberDetailCommonCell : UITableViewCell <MACellReuseProtocol>

@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isEditing;

- (void)setTitle:(NSString *)title detail:(NSString *)detail;

@end