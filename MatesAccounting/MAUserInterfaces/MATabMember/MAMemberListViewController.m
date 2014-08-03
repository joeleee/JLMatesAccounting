//
//  MAMemberListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberListViewController.h"

#import "MAMemberListSectionHeader.h"
#import "MAMemberListSectionEmptyCell.h"
#import "MAMemberListCell.h"
#import "MAAccountManager.h"
#import "MAFriendManager.h"
#import "MFriend.h"
#import "MAMemberDetailViewController.h"

NSString * const kSegueMemberListToMemberDetail = @"kSegueMemberListToMemberDetail";
NSString * const kSegueMemberListToFriendList = @"kSegueMemberListToFriendList";

typedef enum {
    MemberListSectionOfSelected = 0,
    MemberListSectionOfUnselected = 1
} MAMemberListSectionType;

@interface MAMemberListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *saveBarItem;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;
@property (nonatomic, strong) UIBarButtonItem *addFriendBarItem;

@property (nonatomic, strong) MGroup *group;
@property (nonatomic, weak) id <MAMemberListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedMembers;
@property (nonatomic, strong) NSArray *unselectedMembers;
@property (nonatomic, strong) NSMutableArray *modifiedSelectedMembers;
@property (nonatomic, strong) NSMutableArray *modifiedUnselectedMembers;

@end

@implementation MAMemberListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.saveBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSaveNavigationButtonTaped:)];
    [self.saveBarItem setEnabled:NO];
    self.cancelBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelNavigationButtonTaped:)];
    [self.navigationItem setLeftBarButtonItems:@[self.cancelBarItem, self.saveBarItem] animated:YES];

    self.addFriendBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didAddMemberNavigationButtonTaped:)];
    [self.navigationItem setRightBarButtonItem:self.addFriendBarItem animated:YES];

    [self loadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueMemberListToMemberDetail]) {
        MAMemberDetailViewController *memberDetail = segue.destinationViewController;
        [memberDetail setFriend:sender];
    } else if ([segue.identifier isEqualToString:kSegueMemberListToFriendList]) {
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong segue identifier! (MAMemberListViewController)");
    }
}

- (void)setGroup:(MGroup *)group selectedMembers:(NSArray *)selectedMembers delegate:(id<MAMemberListViewControllerDelegate>)delegate
{
    self.group = group;
    self.selectedMembers = selectedMembers;
    self.delegate = delegate;
}

#pragma mark - private

- (BOOL)loadData
{
    if (!self.group) {
        return NO;
    }

    self.modifiedSelectedMembers = [NSMutableArray arrayWithArray:self.selectedMembers];
    self.modifiedUnselectedMembers = [NSMutableArray arrayWithArray:[FriendManager allFriendsByGroup:self.group]];
    [self.modifiedUnselectedMembers removeObjectsInArray:self.selectedMembers];
    self.unselectedMembers = [NSArray arrayWithArray:self.modifiedUnselectedMembers];
    return YES;
}

- (NSMutableArray *)arrayInSection:(NSUInteger)section
{
    switch (section) {
        case MemberListSectionOfSelected: {
            return self.modifiedSelectedMembers;
        }
        case MemberListSectionOfUnselected: {
            return self.modifiedUnselectedMembers;
        }
        default: {
            MA_QUICK_ASSERT(NO, @"MAMemberListViewController unknow section(arrayInSection)");
            break;
        }
    }

    return nil;
}

- (MFriend *)removeMemberAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *memberList = [self arrayInSection:indexPath.section];
    if (0 > indexPath.row || indexPath.row >= memberList.count) {
        return nil;
    }

    [self.saveBarItem setEnabled:YES];
    MFriend *member = [memberList objectAtIndex:indexPath.row];
    [memberList removeObject:member];
    if (0 < memberList.count) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }

    return member;
}

- (void)insertMember:(MFriend *)member atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *memberList = [self arrayInSection:indexPath.section];
    if (!member || 0 > indexPath.row || indexPath.row > memberList.count) {
        return;
    }

    [memberList insertObject:member atIndex:indexPath.row];
    if (1 < memberList.count) {
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }

    return;
}

- (void)didSaveNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(memberListController:didFinishedSelectMember:)]) {
            [self.delegate memberListController:self didFinishedSelectMember:self.modifiedSelectedMembers];
        }
    }];
}

- (void)didCancelNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(memberListControllerDidCancelSelectMember:)]) {
            [self.delegate memberListControllerDidCancelSelectMember:self];
        }
    }];
}

- (void)didAddMemberNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self performSegueWithIdentifier:kSegueMemberListToFriendList sender:nil];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = [self arrayInSection:indexPath.section];
    id cell = nil;
    if (0 < sectionArray.count) {
        MAMemberListCell *memberCell = [tableView dequeueReusableCellWithIdentifier:[MAMemberListCell className]];
        memberCell.actionDelegate = self;
        [memberCell reuseCellWithData:sectionArray[indexPath.row]];
        cell = memberCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[MAMemberListSectionEmptyCell className]];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = [self arrayInSection:section].count;
    if (0 == rowCount) {
        rowCount = 1;
    }

    return rowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *insertIndexPath = nil;
    switch (indexPath.section) {

        case MemberListSectionOfSelected: {
            insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:MemberListSectionOfUnselected];
            break;
        }

        case MemberListSectionOfUnselected: {
            insertIndexPath = [NSIndexPath indexPathForRow:self.modifiedSelectedMembers.count inSection:MemberListSectionOfSelected];
            break;
        }

        default: {
            MA_QUICK_ASSERT(NO, @"MAMemberListViewController unknow section(didSelectRowAtIndexPath)");
            break;
        }
    }

    [self insertMember:[self removeMemberAtIndexPath:indexPath] atIndexPath:insertIndexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MAMemberListSectionHeader *headerView = [MAMemberListSectionHeader headerViewInTableView:tableView];

    switch (section) {
        case MemberListSectionOfSelected: {
            [headerView setHeaderTitle:@"已选择"];
            break;
        }
        case MemberListSectionOfUnselected: {
            [headerView setHeaderTitle:@"未选择"];
            break;
        }
        default: {
            MA_QUICK_ASSERT(NO, @"MAMemberListViewController unknow section(viewForHeaderInSection)");
            break;
        }
    }

    return headerView;
}

#pragma mark MACellActionDelegate
- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    if ([cell isKindOfClass:[MAMemberListCell class]]) {
        [self performSegueWithIdentifier:kSegueMemberListToMemberDetail sender:data];
    }
    return YES;
}

#pragma mark - @property
- (NSMutableDictionary *)userInfo
{
    if (_userInfo) {
        return _userInfo;
    }

    _userInfo = [NSMutableDictionary dictionary];
    return _userInfo;
}

@end