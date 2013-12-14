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
#import "MMember.h"

NSString * const kSegueMemberListToMemberDetail = @"kSegueMemberListToMemberDetail";
NSString * const kSegueMemberListToFriendList = @"kSegueMemberListToFriendList";

typedef enum {
    MemberListSectionOfSelected = 0,
    MemberListSectionOfUnselected = 1
} MAMemberListSectionType;

@interface MAMemberListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *unselectedMembers;
@property (nonatomic, strong) NSMutableArray *selectedMembers;

@end

@implementation MAMemberListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.selectedMembers = [NSMutableArray arrayWithArray:@[@00, @01, @02, @03, @04]];
        self.unselectedMembers = [NSMutableArray arrayWithArray:@[@10, @11, @12, @13, @14, @15]];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addFriendBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didAddMemberNavigationButtonTaped:)];
    [self.navigationItem setRightBarButtonItem:addFriendBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueMemberListToMemberDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueMemberListToFriendList]) {
    } else {
        NSAssert(NO, @"Wrong segue identifier! (MAMemberListViewController)");
    }
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
        if ([memberCell respondsToSelector:@selector(actionDelegate)]) {
            memberCell.actionDelegate = self;
        }
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
            insertIndexPath = [NSIndexPath indexPathForRow:self.selectedMembers.count inSection:MemberListSectionOfSelected];
            break;
        }

        default: {
            NSAssert(NO, @"MAMemberListViewController unknow section(didSelectRowAtIndexPath)");
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
            NSAssert(NO, @"MAMemberListViewController unknow section(viewForHeaderInSection)");
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

#pragma mark - private

#pragma table view
- (NSMutableArray *)arrayInSection:(NSUInteger)section
{
    switch (section) {
        case MemberListSectionOfSelected: {
            return self.selectedMembers;
        }
        case MemberListSectionOfUnselected: {
            return self.unselectedMembers;
        }
        default: {
            NSAssert(NO, @"MAMemberListViewController unknow section(arrayInSection)");
            break;
        }
    }

    return nil;
}

- (MMember *)removeMemberAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *memberList = [self arrayInSection:indexPath.section];
    if (0 > indexPath.row || indexPath.row >= memberList.count) {
        return nil;
    }

    MMember *member = [memberList objectAtIndex:indexPath.row];
    [memberList removeObject:member];
    if (0 < memberList.count) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }

    return member;
}

- (void)insertMember:(MMember *)member atIndexPath:(NSIndexPath *)indexPath
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

#pragma UI action
- (void)didAddMemberNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self performSegueWithIdentifier:kSegueMemberListToFriendList sender:nil];
}

@end