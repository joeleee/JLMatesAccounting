//
//  MAGroupListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupListViewController.h"

#import "MAGroupManager.h"
#import "MAGroupListCell.h"

@interface MAGroupListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MAGroupListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
    }

    return self;
}

- (void)loadView
{
    [super loadView];
    [self setTitle:@"账小组"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    // TODO:
    // return [GroupManager myGroups].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAGroupListCell className]];

    return cell;
}

#pragma mark private

#pragma mark data
- (void)loadData
{
    [GroupManager myGroups];
}

@end