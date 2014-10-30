//
//  UITableView+MAAddition.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-10-30.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "UITableView+MAAddition.h"

@implementation UITableView (MAAddition)

- (void)scrollToFirstRow:(BOOL)animated
{
    if (0 >= self.numberOfSections || 0 >= [self numberOfRowsInSection:0]) {
        return;
    }
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)scrollToLastRow:(BOOL)animated
{
    if (0 >= self.numberOfSections || 0 >= [self numberOfRowsInSection:self.numberOfSections - 1]) {
        return;
    }
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self numberOfRowsInSection:self.numberOfSections - 1] - 1 inSection:self.numberOfSections - 1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)reloadDataWithAnimation:(BOOL)animated
{
    [self reloadData];

    if (animated) {
        NSRange sectionRange;
        sectionRange.location = 0;
        sectionRange.length = self.numberOfSections;
        [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionRange] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end