//
//  MAMemberAccountListSectionHeader.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-21.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kMemberAccountListSectionHeaderHeight;

@interface MAMemberAccountListSectionHeader : UITableViewHeaderFooterView

- (void)reuseWithHeaderTitle:(NSString *)title;

@end