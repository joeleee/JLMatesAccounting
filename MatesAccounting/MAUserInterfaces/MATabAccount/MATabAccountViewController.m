//
//  MATabAccountViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountViewController.h"

#import "MAGroupManager.h"
#import "MAAccountManager.h"
#import "MATabAccountListSectionHeader.h"
#import "MAGroupListViewController.h"
#import "MATabAccountGroupInfoCell.h"
#import "MATabAccountListCell.h"

NSString * const kSegueTabAccountToGroupList = @"kSegueTabAccountToGroupList";

@interface MATabAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MATabAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController setTitle:@"账目"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *addAccountBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addAccountBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabAccountToGroupList]) {
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    }
    return 10;

    // TODO:
    if (0 == section) {
        return 1;
    } else if ((section - 1) < [AccountManager sectionedAccountListForCurrentGroup].count) {
        return [[AccountManager sectionedAccountListForCurrentGroup][section - 1] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (0 == indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountGroupInfoCell className]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountListCell className]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;

    // TODO:
    if (NO && ![GroupManager currentGroup]) {
        return 0;
    } else {
        return [AccountManager sectionedAccountListForCurrentGroup].count + 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return kTabAccountListSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MATabAccountListSectionHeader *headerView = [[MATabAccountListSectionHeader alloc] initWithHeaderTitle:@"未知错误"];
    if (0 == section) {
        [headerView setHeaderTitle:@"账户组信息"];
    } else if (((section - 1) < [AccountManager sectionedAccountListForCurrentGroup].count)) {
        [headerView setHeaderTitle:@"2011年11月11日"];
    }
    return headerView;
}

#pragma mark - private method

#pragma mark UI

#pragma mark data
- (void)loadData
{
    [GroupManager currentGroup];

    [AccountManager sectionedAccountListForCurrentGroup];
}

#pragma mark action
- (void)addAccountNavigationButtonTaped:(id)sender
{
}

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToGroupList sender:[GroupManager currentGroup]];
}

@end
