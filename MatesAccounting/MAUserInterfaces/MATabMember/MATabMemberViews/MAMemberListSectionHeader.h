//
//  MAMemberListSectionHeader.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAMemberListSectionHeader : UITableViewHeaderFooterView

+ (id)headerViewInTableView:(UITableView *)tableView;

- (void)setHeaderTitle:(NSString *)headerTitle;

@end