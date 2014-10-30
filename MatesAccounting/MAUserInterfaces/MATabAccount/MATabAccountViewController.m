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
#import "MATabTableView.h"

NSString * const kSegueTabAccountToGroupList = @"kSegueTabAccountToGroupList";
NSString * const kSegueTabAccountToAccountDetail = @"kSegueTabAccountToAccountDetail";
NSString * const kSegueTabAccountToNewAccount = @"kSegueTabAccountToNewAccount";


@interface MATabAccountViewController () <UITableViewDataSource, UITableViewDelegate, MAGroupManagerObserverProtocol, MAAccountManagerObserverProtocol>

@property (weak, nonatomic) IBOutlet MATabTableView *tableView;
@property (nonatomic, strong) NSArray *sectionedAccountList;
@property (nonatomic, assign) BOOL needReloadDataWhenAppear;

@end


@implementation MATabAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
        [GroupManager registerGroupObserver:self];
        [AccountManager registerGroupObserver:self];
        self.needReloadDataWhenAppear = NO;
    }

    return self;
}

- (void)dealloc
{
    [GroupManager unregisterGroupObserver:self];
    [AccountManager unregisterGroupObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];
    [self.tableView setContentInset:self.tableView.contentInset];
    [self.tableView scrollToFirstRow:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"Accounts"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *addAccountBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addAccountBarItem animated:YES];

    if (self.needReloadDataWhenAppear) {
        self.needReloadDataWhenAppear = NO;
        [self loadData];
        [self.tableView reloadDataWithAnimation:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.tableView.contentOffset.y < -self.tableView.contentInset.top) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, -self.tableView.contentInset.top) animated:animated];
    }
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
        [accountDetail setAccount:account];
    } else if ([segue.identifier isEqualToString:kSegueTabAccountToNewAccount]) {
        MA_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAAccountDetailViewController *accountDetail = [segue.destinationViewController viewControllers][0];
        [accountDetail setGroup:MACurrentGroup];
    } else {
        MA_ASSERT(NO, @"Wrong segue in [MATabAccountViewController prepareForSegue: sender:] !");
    }
}

- (void)loadData
{
    self.sectionedAccountList = [AccountManager sectionedAccountListForGroup:MACurrentGroup];
}


#pragma mark - actions

- (void)addAccountNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToNewAccount sender:nil];
}

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabAccountToGroupList sender:MACurrentGroup];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (!MACurrentGroup) {
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
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountGroupInfoCell className]];
        [(MATabAccountGroupInfoCell *)cell reuseCellWithData:MACurrentGroup];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MATabAccountListCell className]];
        NSArray *accountList = (0 < indexPath.section && indexPath.section <= self.sectionedAccountList.count) ? self.sectionedAccountList[indexPath.section - 1] : nil;
        MAccount *account = indexPath.row < accountList.count ? accountList[indexPath.row] : nil;
        [(MATabAccountListCell *)cell reuseCellWithData:account];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return [MATabAccountGroupInfoCell cellHeight:nil];
    } else {
        return [MATabAccountListCell cellHeight:nil];
    }
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
        MA_ASSERT(NO, @"Out of bound!");
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }

    MATabAccountListSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MATabAccountListSectionHeader className]];
    if (!headerView) {
        headerView = [[MATabAccountListSectionHeader alloc] initWithReuseIdentifier:[MATabAccountListSectionHeader className]];
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
        MA_ASSERT(NO, @"Out of bound!");
    }
    return headerView;
}


#pragma mark - MAGroupManagerObserverProtocol

- (void)groupInfoDidChanged:(MGroup *)group
{
    if (MACurrentGroup == group) {
        if (0 < [self.tableView numberOfSections]) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd
{
    if (MACurrentGroup == group) {
        if (0 < [self.tableView numberOfSections]) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)currentGroupDidSwitched:(MGroup *)group
{
    [self.tableView scrollToFirstRow:NO];
    if (![self isTopViewController]) {
        self.needReloadDataWhenAppear = YES;
        return;
    }

    [self loadData];
    [self.tableView reloadData];
}


#pragma mark - MAAccountManagerObserverProtocol

- (void)accountDidChanged:(MAccount *)account
{
    if (MACurrentGroup == account.group) {
        [self.tableView reloadData];
    }
}

- (void)accountDidCreated:(MAccount *)account
{
    if (MACurrentGroup == account.group) {
        if (![self isTopViewController]) {
            self.needReloadDataWhenAppear = YES;
            return;
        }

        [self loadData];
        [self.tableView reloadData];
    }
}

- (void)accountDidDeletedInGroup:(MGroup *)group
{
    if (MACurrentGroup == group) {
        if (![self isTopViewController]) {
            self.needReloadDataWhenAppear = YES;
            return;
        }

        [self loadData];
        [self.tableView reloadData];
    }
}

@end