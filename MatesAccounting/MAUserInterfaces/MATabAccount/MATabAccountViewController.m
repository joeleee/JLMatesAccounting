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
#import "MAAccountDetailViewController.h"

NSString * const kSegueTabAccountToGroupList = @"kSegueTabAccountToGroupList";
NSString * const kSegueTabAccountToAccountDetail = @"kSegueTabAccountToAccountDetail";
NSString * const kSegueTabAccountToNewAccount = @"kSegueTabAccountToNewAccount";

@interface MATabAccountViewController () <UITableViewDataSource, UITableViewDelegate, MAGroupManagerListenerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionedAccountList;

@end

@implementation MATabAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"账目"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *addAccountBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addAccountBarItem animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [GroupManager addListener:self];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GroupManager removeListener:self];

    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabAccountToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToAccountDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToNewAccount]) {
        MA_QUICK_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAAccountDetailViewController *accountDetail = [segue.destinationViewController viewControllers][0];
        [accountDetail setIsCreateMode:YES];
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong segue in [MATabAccountViewController prepareForSegue: sender:] !");
    }
}

- (void)loadData
{
    self.sectionedAccountList = [AccountManager sectionedAccountListForCurrentGroup];
    [self.tableView reloadData];
}

#pragma mark - actions

- (void)addAccountNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToNewAccount sender:nil];
}

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToGroupList sender:[GroupManager currentGroup]];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (![GroupManager currentGroup]) {
        return 0;
    } else {
        return self.sectionedAccountList.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    } else if ((section - 1) < self.sectionedAccountList.count) {
        return [self.sectionedAccountList[section - 1] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (0 == indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountGroupInfoCell reuseIdentifier]];
        [(MATabAccountGroupInfoCell *)cell reuseCellWithData:[GroupManager currentGroup]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountListCell reuseIdentifier]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO:
    if (0 == indexPath.section) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self performSegueWithIdentifier:kSegueTabAccountToAccountDetail sender:nil];
    }
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

#pragma mark - MAGroupManagerListenerProtocol

- (void)currentGroupHasChanged:(MGroup *)group
{
    [self loadData];
}

@end
