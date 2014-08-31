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

NSString * const kSegueFriendListToCreateMember = @"kSegueFriendListToCreateMember";

@interface MAFriendListViewController () <UITableViewDataSource, UITableViewDelegate>

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
        MA_QUICK_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setFriend:nil];
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow segue - MAFriendListViewController");
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
    MA_QUICK_ASSERT(indexPath.row < self.friendList.count, @"%@ %s wrong indexPath.");
    MAFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAFriendListCell className]];
    [cell reuseCellWithData:self.friendList[indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.navigationItem rightBarButtonItem] != self.selectDoneBarItem) {
        [self.navigationItem setRightBarButtonItem:self.selectDoneBarItem animated:YES];
    }
    [self.selectDoneBarItem setTitle:[NSString stringWithFormat:@"Done(%lu)", (unsigned long)tableView.indexPathsForSelectedRows.count]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 >= [[tableView indexPathsForSelectedRows] count]) {
        [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
    }
    [self.selectDoneBarItem setTitle:[NSString stringWithFormat:@"Done(%lu)", (unsigned long)tableView.indexPathsForSelectedRows.count]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        MA_QUICK_ASSERT(indexPath.row < self.friendList.count, @"indexPath wrong");
        MFriend *mFriend = self.friendList[indexPath.row];
        if ([FriendManager deleteFriend:mFriend]) {
            self.friendList = [FriendManager allFriendsFilteByGroup:self.group];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSArray *unpaidGroups = [FriendManager unpaidGroupsForFriend:mFriend];
            if (0 < unpaidGroups.count) {
                NSMutableString *unpaidGroupNames = [NSMutableString string];
                for (MGroup *group in unpaidGroups) {
                    if (group == unpaidGroups.firstObject) {
                        [unpaidGroupNames appendFormat:@"%@", group.groupName];
                    } else {
                        [unpaidGroupNames appendFormat:@", %@", group.groupName];
                    }
                }
                NSString *message = [NSString stringWithFormat:@"%@ has %lu unpaid groups: %@", mFriend.name, (unsigned long)unpaidGroups.count, unpaidGroupNames];
                [[MAAlertView alertWithTitle:@"Delete friend failed" message:message buttonBlocks:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                [[MAAlertView alertWithTitle:@"Delete friend failed!" message:nil buttonBlocks:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }
}

@end