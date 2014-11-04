//
//  MAFriendListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendListViewController.h"

#import "MFriend.h"
#import "MGroup+expand.h"
#import "RMemberToGroup+expand.h"
#import "MAFriendListCell.h"
#import "MAMemberDetailViewController.h"
#import "MAFriendManager.h"
#import "MAGroupManager.h"
#import "MAFriendListAddFromContactCell.h"

NSString * const kSegueFriendListToCreateMember = @"kSegueFriendListToCreateMember";

@interface MAFriendListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *createFriendBarItem;
@property (nonatomic, strong) UIBarButtonItem *selectDoneBarItem;

@property (nonatomic, strong) NSArray *friendList;

@end

@implementation MAFriendListViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueFriendListToCreateMember]) {
        MA_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setFriend:nil];
    } else {
        MA_ASSERT(NO, @"Unknow segue - MAFriendListViewController");
    }
}

- (void)loadData
{
    self.friendList = [FriendManager allFriendsFilteByGroup:self.group];
    if (1 == self.tableView.numberOfSections) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark @property method

- (UIBarButtonItem *)createFriendBarItem
{
    if (_createFriendBarItem) {
        return _createFriendBarItem;
    }

    _createFriendBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didCreateNavigationButtonTaped:)];
    return _createFriendBarItem;
}

- (UIBarButtonItem *)selectDoneBarItem
{
    if (_selectDoneBarItem) {
        return _selectDoneBarItem;
    }

    _selectDoneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectDoneNavigationButtonTaped:)];
    return _selectDoneBarItem;
}

#pragma mark UI action

- (void)didCreateNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self performSegueWithIdentifier:kSegueFriendListToCreateMember sender:nil];
}

- (void)didSelectDoneNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
        [GroupManager addFriend:self.friendList[indexPath.row] toGroup:self.group];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    UITableViewCell *cell;
    if (indexPath.row == self.friendList.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:MAFriendListAddFromContactCell.className];
        [(MAFriendListAddFromContactCell *)cell reuseCellWithData:@"Add friend from contact"];
        [(MAFriendListAddFromContactCell *)cell setActionDelegate:self];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:MAFriendListCell.className];
        [(MAFriendListCell *)cell reuseCellWithData:self.friendList[indexPath.row]];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendList.count + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    if (indexPath.row == self.friendList.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    if ([self.navigationItem rightBarButtonItem] != self.selectDoneBarItem) {
        [self.navigationItem setRightBarButtonItem:self.selectDoneBarItem animated:YES];
    }
    [self.selectDoneBarItem setTitle:[NSString stringWithFormat:@"Done(%lu)", (unsigned long)tableView.indexPathsForSelectedRows.count]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    if (indexPath.row == self.friendList.count) {
        return;
    }

    if (0 >= [[tableView indexPathsForSelectedRows] count]) {
        [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
    }
    [self.selectDoneBarItem setTitle:[NSString stringWithFormat:@"Done(%lu)", (unsigned long)tableView.indexPathsForSelectedRows.count]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    if (indexPath.row == self.friendList.count) {
        return NO;
    }

    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    if (indexPath.row == self.friendList.count) {
        return UITableViewCellEditingStyleNone;
    }

    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row <= self.friendList.count, @"%@ %s wrong indexPath.");

    if (indexPath.row == self.friendList.count) {
        return;
    }

    if (UITableViewCellEditingStyleDelete == editingStyle) {
        MFriend *mFriend = self.friendList[indexPath.row];
        [FriendManager deleteFriend:mFriend onComplete:^(id result, NSError *error) {
            self.friendList = [FriendManager allFriendsFilteByGroup:self.group];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        } onFailed:^(id result, NSError *error) {
            [[MAAlertView alertWithTitle:@"Can't Delete" message:error.domain buttonTitle:@"OK" buttonBlock:^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            }] show];
        }];
    }
}


#pragma mark - MACellActionDelegate

- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    if ([cell isKindOfClass:MAFriendListAddFromContactCell.class]) {
        return YES;
    }

    return NO;
}

@end