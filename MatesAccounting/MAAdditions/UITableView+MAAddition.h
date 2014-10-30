//
//  UITableView+MAAddition.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-10-30.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (MAAddition)

- (void)scrollToFirstRow:(BOOL)animated;

- (void)scrollToLastRow:(BOOL)animated;

- (void)reloadDataWithAnimation:(BOOL)animated;

@end