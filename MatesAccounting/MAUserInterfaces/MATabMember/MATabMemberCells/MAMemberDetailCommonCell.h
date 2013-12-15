//
//  MAMemberDetailCell.h
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MABaseCell.h"

@interface MAMemberDetailCommonCell : MABaseCell

@property (nonatomic, assign) UIKeyboardType keyboardType;

- (void)setTitle:(NSString *)title detail:(NSString *)detail;

@end