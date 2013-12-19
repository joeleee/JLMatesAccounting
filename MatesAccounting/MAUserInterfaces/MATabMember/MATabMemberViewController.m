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
#import "MAMemberManager.h"

NSString * const kSegueTabMemberToGroupList = @"kSegueTabMemberToGroupList";
NSString * const kSegueTabMemberToMemberDetail = @"kSegueTabMemberToMemberDetail";
NSString * const kSegueTabMemberToCreateMember = @"kSegueTabMemberToCreateMember";
NSString * const kSegueTabMemberToFriendList = @"kSegueTabMemberToFriendList";

@interface MATabMemberViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MATabMemberViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"账组成员"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didGroupNavigationButtonTaped:)];
    UIBarButtonItem *moreBarItem = [[UIBarButtonItem alloc] initWithTitle:@"•••" style:UIBarButtonItemStyleDone target:self action:@selector(didMoreNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:moreBarItem animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -64);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabMemberToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToMemberDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToCreateMember]) {
        NSAssert(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setIsCreateMode:YES];
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToFriendList]) {
    } else {
        NSAssert(NO, @"Wrong segue! (MATabMemberViewController)");
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MATabMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MATabMemberListCell className]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = [MemberManager currentGroupMembers].count;

    // TODO: test data
    rowCount = 18;

    return rowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSegueTabMemberToMemberDetail sender:nil];
}

#pragma mark data
- (void)loadData
{
    [MemberManager currentGroupMembers];
}

#pragma mark navigation action
- (void)didGroupNavigationButtonTaped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueTabMemberToGroupList sender:[GroupManager currentGroup]];
}

#pragma mark navigation action
- (void)didMoreNavigationButtonTaped:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多操作"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"新建好友", @"添加好友到账组", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            [self performSegueWithIdentifier:kSegueTabMemberToCreateMember sender:[GroupManager currentGroup]];
            break;
        }
        case 1: {
            [self performSegueWithIdentifier:kSegueTabMemberToFriendList sender:[GroupManager currentGroup]];
            break;
        }
        case 2:
        default:
            break;
    }
}

@end