//
//  MATabAccountListSectionHeader.h
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kTabAccountListSectionHeaderHeight;

@interface MATabAccountListSectionHeader : UITableViewHeaderFooterView

- (void)reuseWithHeaderTitle:(NSString *)title;

@end