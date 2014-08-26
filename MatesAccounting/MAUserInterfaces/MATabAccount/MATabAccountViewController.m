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
#import "MAccount.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    UIEdgeInsets tableViewEdgeInsets = UIEdgeInsetsMake(MA_STATUSBAR_HEIGHT + MA_NAVIGATIONBAR_HEIGHT, 0.0f, MA_TABBAR_HEIGHT, 0.0f);
    [self.tableView setContentInset:tableViewEdgeInsets];
    [self.tableView setScrollIndicatorInsets:tableViewEdgeInsets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"Accounts"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *addAccountBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addAccountBarItem animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabAccountToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToAccountDetail]) {
        NSIndexPath *indexPath = [(UITableView *)sender indexPathForSelectedRow];
        MAAccountDetailViewController *accountDetail = segue.destinationViewController;
        NSArray *accountList = (0 < indexPath.section && indexPath.section <= self.sectionedAccountList.count) ? self.sectionedAccountList[indexPath.section - 1] : nil;
        MAccount *account = indexPath.row < accountList.count ? accountList[indexPath.row] : nil;
        [accountDetail setGroup:MASelectedGroup account:account];
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToNewAccount]) {
        MA_QUICK_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAAccountDetailViewController *accountDetail = [segue.destinationViewController viewControllers][0];
        [accountDetail setGroup:MASelectedGroup account:nil];
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong segue in [MATabAccountViewController prepareForSegue: sender:] !");
    }
}

- (void)loadData
{
    self.sectionedAccountList = [AccountManager sectionedAccountListForGroup:MASelectedGroup];
    [self.tableView reloadData];
}

#pragma mark - actions

- (void)addAccountNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToNewAccount sender:nil];
}

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToGroupList sender:MASelectedGroup];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (!MASelectedGroup) {
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
        [(MATabAccountGroupInfoCell *)cell reuseCellWithData:MASelectedGroup];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountListCell reuseIdentifier]];
        NSArray *accountList = (0 < indexPath.section && indexPath.section <= self.sectionedAccountList.count) ? self.sectionedAccountList[indexPath.section - 1] : nil;
        MAccount *account = indexPath.row < accountList.count ? accountList[indexPath.row] : nil;
        [(MATabAccountListCell *)cell reuseCellWithData:account];
        [(MATabAccountListCell *)cell dividingLineView].hidden = (accountList.lastObject == account);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self performSegueWithIdentifier:kSegueTabAccountToAccountDetail sender:tableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0;
    } else if (((section - 1) < self.sectionedAccountList.count)) {
        return kTabAccountListSectionHeaderHeight;
    } else {
        MA_QUICK_ASSERT(NO, @"Out of bound!");
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }

    MATabAccountListSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MATabAccountListSectionHeader"];
    if (!headerView) {
        headerView = [[MATabAccountListSectionHeader alloc] initWithReuseIdentifier:@"MATabAccountListSectionHeader"];
    }

    if (((section - 1) < self.sectionedAccountList.count)) {
        MAccount *account = [self.sectionedAccountList[section - 1] firstObject];
        NSInteger currentYear = [[[NSDate date] dateToString:@"yyyy"] integerValue];
        if ([[account.accountDate dateToString:@"yyyy"] integerValue] == currentYear) {
            [headerView reuseWithHeaderTitle:[account.accountDate dateToString:@"MM-dd"]];
        } else {
            [headerView reuseWithHeaderTitle:[account.accountDate dateToString:@"yyyy-MM-dd"]];
        }
    } else {
        [headerView reuseWithHeaderTitle:@""];
        MA_QUICK_ASSERT(NO, @"Out of bound!");
    }
    return headerView;
}

#pragma mark - MAGroupManagerListenerProtocol

- (void)currentGroupHasChanged:(MGroup *)group
{
    [self loadData];
}

@end
