//
//  MAMemberAccountListViewController.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-9-15.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAMemberAccountListViewController.h"

#import "MFriend.h"
#import "MGroup+expand.h"
#import "MAccount+expand.h"
#import "RMemberToAccount.h"
#import "MAMemberAccountListCell.h"
#import "MAMemberAccountListSectionHeader.h"
#import "MAAccountDetailViewController.h"

NSString * const kSegueMemberAccountListToAccountDetail = @"kSegueMemberAccountListToAccountDetail";

@interface MAMemberAccountListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *accountsCategories;

@end

@implementation MAMemberAccountListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueMemberAccountListToAccountDetail]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath.section >= self.accountsCategories.count ||
            indexPath.row >= [self.accountsCategories[indexPath.section] count]) {
            MA_QUICK_ASSERT(NO, @"self.accountsCategories out of bounds!");
            return;
        }
        MAccount *account = [self.accountsCategories[indexPath.section] objectAtIndex:indexPath.row];
        MAAccountDetailViewController *accountDetail = segue.destinationViewController;
        [accountDetail setAccount:account];
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong segue!");
    }
}

- (void)loadData
{
    if (!self.member) {
        self.accountsCategories = nil;
        [self.tableView reloadData];
        return;
    }

    NSMutableDictionary *categoriesDict = [NSMutableDictionary dictionary];
    NSMutableArray *groups = [NSMutableArray array];
    for (RMemberToAccount *memberToAccount in self.member.relationshipToAccount) {
        NSMutableArray *accounts = categoriesDict[memberToAccount.account.group.groupName];
        if (accounts) {
            [accounts addObject:memberToAccount.account];
        } else {
            accounts = [NSMutableArray arrayWithObject:memberToAccount.account];
            categoriesDict[memberToAccount.account.group.groupName] = accounts;
            [groups addObject:memberToAccount.account.group];
        }
    }

    [groups sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO]]];
    NSMutableArray *resultData = [NSMutableArray array];
    for (MGroup *group in groups) {
        NSArray *accounts = categoriesDict[group.groupName];
        [resultData addObject:[accounts sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"accountDate" ascending:NO]]]];
    }

    self.accountsCategories = resultData;
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.accountsCategories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kMemberAccountListSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section >= self.accountsCategories.count) {
        MA_QUICK_ASSERT(NO, @"self.accountsCategories out of bounds!");
        return nil;
    }

    MAMemberAccountListSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MAMemberAccountListSectionHeader className]];
    if (!headerView) {
        headerView = [[MAMemberAccountListSectionHeader alloc] initWithReuseIdentifier:[MAMemberAccountListSectionHeader className]];
    }
    MAccount *account = [self.accountsCategories[section] firstObject];
    [headerView reuseWithHeaderTitle:account.group.groupName];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.accountsCategories.count) {
        MA_QUICK_ASSERT(NO, @"self.accountsCategories out of bounds!");
        return 0;
    }

    NSInteger rows = [self.accountsCategories[section] count];
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.accountsCategories.count ||
        indexPath.row >= [self.accountsCategories[indexPath.section] count]) {
        MA_QUICK_ASSERT(NO, @"self.accountsCategories out of bounds!");
        return 0;
    }

    MAccount *account = [self.accountsCategories[indexPath.section] objectAtIndex:indexPath.row];
    CGFloat height = [MAMemberAccountListCell cellHeight:account];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAMemberAccountListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MAMemberAccountListCell className]];
    if (indexPath.section >= self.accountsCategories.count ||
        indexPath.row >= [self.accountsCategories[indexPath.section] count]) {
        MA_QUICK_ASSERT(NO, @"self.accountsCategories out of bounds!");
        return cell;
    }

    MAccount *account = [self.accountsCategories[indexPath.section] objectAtIndex:indexPath.row];
    [cell reuseCellWithData:account];
    cell.miniBackgroundView.frame = cell.miniBackgroundView.superview.frame;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSegueMemberAccountListToAccountDetail sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark property methods
- (void)setMember:(MFriend *)member
{
    if (_member == member) {
        return;
    }

    [self willChangeValueForKey:@"member"];
    _member = member;
    [self didChangeValueForKey:@"member"];
    [self loadData];
}

@end