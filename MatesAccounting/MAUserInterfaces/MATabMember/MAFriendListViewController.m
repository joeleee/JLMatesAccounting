//
//  MAFriendListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendListViewController.h"

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

    [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];

    self.friendList = [FriendManager allFriendsFilteByGroup:self.group];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueFriendListToCreateMember]) {
        MA_QUICK_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setIsCreateMode:YES];
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow segue - MAFriendListViewController");
    }
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 >= [[tableView indexPathsForSelectedRows] count]) {
        [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
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

    _selectDoneBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDoneNavigationButtonTaped:)];
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

@end