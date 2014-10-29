//
//  MATabMemberViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMemberViewController.h"

#import "MAGroupManager.h"
#import "MAMemberDetailViewController.h"
#import "MATabMemberListCell.h"
#import "MAFriendManager.h"
#import "MAFriendListViewController.h"
#import "RMemberToGroup+expand.h"
#import "MAAccountManager.h"
#import "MAccount+expand.h"
#import "MFriend.h"
#import "MGroup+expand.h"


NSString * const kSegueTabMemberToGroupList = @"kSegueTabMemberToGroupList";
NSString * const kSegueTabMemberToMemberDetail = @"kSegueTabMemberToMemberDetail";
NSString * const kSegueTabMemberToCreateMember = @"kSegueTabMemberToCreateMember";
NSString * const kSegueTabMemberToFriendList = @"kSegueTabMemberToFriendList";


@interface MATabMemberViewController () <UITableViewDataSource, UITableViewDelegate, MAGroupManagerObserverProtocol, MAAccountManagerObserverProtocol, MAFriendManagerObserverProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *groupToMemberList;

@end


@implementation MATabMemberViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [self loadData];
        [GroupManager registerGroupObserver:self];
        [AccountManager registerGroupObserver:self];
        [FriendManager registerFriendObserver:self];
    }

    return self;
}

- (void)dealloc
{
    [GroupManager unregisterGroupObserver:self];
    [AccountManager unregisterGroupObserver:self];
    [FriendManager unregisterFriendObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];
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
    [self.tabBarController setTitle:@"Members"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didGroupNavigationButtonTaped:)];
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didAddNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addBarItem animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabMemberToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToMemberDetail]) {
        MAMemberDetailViewController *memberDetail = segue.destinationViewController;
        [memberDetail setFriend:sender];
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToCreateMember]) {
        MA_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setFriend:nil];
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToFriendList]) {
        MAFriendListViewController *controller = segue.destinationViewController;
        controller.group = sender;
    } else {
        MA_ASSERT(NO, @"Wrong segue! (MATabMemberViewController)");
    }
}

- (void)loadData
{
    NSArray *dataList = [FriendManager currentGroupToMemberRelationships];

    if (self.groupToMemberList.count == dataList.count) {
        self.groupToMemberList = dataList;
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

    } else {
        self.groupToMemberList = dataList;
        if (1 == [self.tableView numberOfSections]) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
    MATabMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MATabMemberListCell className]];
    RMemberToGroup *memberToGroup = self.groupToMemberList[indexPath.row];
    [cell reuseCellWithData:memberToGroup.member];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupToMemberList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
    RMemberToGroup *memberToGroup = self.groupToMemberList[indexPath.row];
    [self performSegueWithIdentifier:kSegueTabMemberToMemberDetail sender:memberToGroup.member];
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
        self.tableView.editing = YES;
        MA_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
        RMemberToGroup *memberToGroup = self.groupToMemberList[indexPath.row];
        [memberToGroup refreshMemberTotalFee];
        [GroupManager removeFriend:memberToGroup.member fromGroup:memberToGroup.group onComplete:^(id result, NSError *error) {
            self.tableView.editing = NO;
            self.groupToMemberList = [FriendManager currentGroupToMemberRelationships];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        } onFailed:^(id result, NSError *error) {
            [[MAAlertView alertWithTitle:@"Can't Delete" message:error.domain buttonTitle:@"OK" buttonBlock:^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                self.tableView.editing = NO;
            }] show];
        }];
    }
}


#pragma mark - MAGroupManagerObserverProtocol

- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd
{
    if (MACurrentGroup == group && !self.tableView.editing) {
        [self loadData];
    }
}

- (void)currentGroupDidSwitched:(MGroup *)group
{
    [self loadData];
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
        [self.tableView reloadData];
    }
}

- (void)accountDidDeletedInGroup:(MGroup *)group
{
    if (MACurrentGroup == group) {
        [self.tableView reloadData];
    }
}


#pragma mark - MAFriendManagerObserverProtocol

- (void)friendDidChanged:(MFriend *)mFriend
{
    if (0 < [MACurrentGroup relationshipToMembersByFriend:mFriend].count) {
        [self.tableView reloadData];
    }
}


#pragma mark - UI action

- (void)didGroupNavigationButtonTaped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueTabMemberToGroupList sender:MACurrentGroup];
}

- (void)didAddNavigationButtonTaped:(UIBarButtonItem *)sender
{
    if (!MACurrentGroup) {
        [MBProgressHUD showTextHUDOnView:self.view
                                    text:@"You need select a group first"
                         completionBlock:nil
                                animated:YES];
    } else {
        [self performSegueWithIdentifier:kSegueTabMemberToFriendList sender:MACurrentGroup];
    }
}

@end