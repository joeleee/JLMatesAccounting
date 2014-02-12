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

@interface MATabAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MATabAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(currentGroupHasChanged:)
                                                     name:MAGroupManagerSelectedGroupChanged
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabAccountToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToAccountDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToNewAccount]) {
        NSAssert(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAAccountDetailViewController *accountDetail = [segue.destinationViewController viewControllers][0];
        [accountDetail setIsCreateMode:YES];
    } else {
        NSAssert(NO, @"Wrong segue in [MATabAccountViewController prepareForSegue: sender:] !");
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
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountGroupInfoCell reuseIdentifier]];
        [(MATabAccountGroupInfoCell *)cell reuseCellWithData:[GroupManager currentGroup]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountListCell reuseIdentifier]];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (![GroupManager currentGroup]) {
        return 0;
    } else {
        // TODO:
        return 5;
        return [AccountManager sectionedAccountListForCurrentGroup].count + 1;
    }
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

#pragma mark - actions

- (void)addAccountNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToNewAccount sender:nil];
}

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToGroupList sender:[GroupManager currentGroup]];
}

#pragma mark - notifications

- (void)currentGroupHasChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

@end
