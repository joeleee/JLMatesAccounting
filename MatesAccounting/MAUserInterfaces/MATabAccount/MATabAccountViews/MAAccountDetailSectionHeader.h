//
//  MAAccountDetailSectionHeader.h
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kAccountDetailSectionHeaderHeight;

@interface MAAccountDetailSectionHeader : UIView

- (MAAccountDetailSectionHeader *)initWithHeaderTitle:(NSString *)title;

- (void)setHeaderTitle:(NSString *)headerTitle;

@end