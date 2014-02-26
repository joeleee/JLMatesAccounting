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
#import "RMemberToGroup.h"

NSString * const kSegueTabMemberToGroupList = @"kSegueTabMemberToGroupList";
NSString * const kSegueTabMemberToMemberDetail = @"kSegueTabMemberToMemberDetail";
NSString * const kSegueTabMemberToCreateMember = @"kSegueTabMemberToCreateMember";
NSString * const kSegueTabMemberToFriendList = @"kSegueTabMemberToFriendList";

@interface MATabMemberViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *groupToMemberList;

@end

@implementation MATabMemberViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -64);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"账组成员"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didGroupNavigationButtonTaped:)];
    UIBarButtonItem *addBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didAddNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addBarItem animated:YES];
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
    if ([segue.identifier isEqualToString:kSegueTabMemberToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToMemberDetail]) {
        MAMemberDetailViewController *memberDetail = segue.destinationViewController;
        [memberDetail setMFriend:sender];
        [memberDetail setIsCreateMode:NO];
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToCreateMember]) {
        MA_QUICK_ASSERT(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setIsCreateMode:YES];
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToFriendList]) {
        MAFriendListViewController *controller = segue.destinationViewController;
        controller.group = sender;
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong segue! (MATabMemberViewController)");
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
    MA_QUICK_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
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
    MA_QUICK_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
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
        MA_QUICK_ASSERT(indexPath.row < self.groupToMemberList.count, @"indexPath wrong");
        RMemberToGroup *memberToGroup = self.groupToMemberList[indexPath.row];
        if ([GroupManager removeFriend:memberToGroup.member fromGroup:memberToGroup.group]) {
            self.groupToMemberList = [FriendManager currentGroupToMemberRelationships];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [MBProgressHUD showTextHUDOnView:self.view
                                        text:@"报告，移除成员失败了..."
                             completionBlock:nil
                                    animated:YES];
        }
    }
}

#pragma mark - UI action
- (void)didGroupNavigationButtonTaped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueTabMemberToGroupList sender:[GroupManager currentGroup]];
}

- (void)didAddNavigationButtonTaped:(UIBarButtonItem *)sender
{
    if (![GroupManager currentGroup]) {
        [MBProgressHUD showTextHUDOnView:self.view
                                    text:@"还木有选小组，肿么添加成员~"
                         completionBlock:nil
                                animated:YES];
    } else {
        [self performSegueWithIdentifier:kSegueTabMemberToFriendList sender:[GroupManager currentGroup]];
    }
}

@end