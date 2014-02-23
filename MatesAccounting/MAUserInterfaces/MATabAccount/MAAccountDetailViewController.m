//
//  MAAccountDetailViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailViewController.h"

#import "MAAccountDetailFeeCell.h"
#import "MAAccountDetailDateCell.h"
#import "MAAccountDetailPayersCell.h"
#import "MAAccountDetailConsumersCell.h"
#import "MAAccountDetailLocationCell.h"
#import "MAAccountDetailConsumerDetailCell.h"
#import "MAAccountDetailDescriptionCell.h"
#import "MAAccountDetailSectionHeader.h"
#import "MAccount+expand.h"

typedef enum {
    FeeSectionType = 0,
    AccountDetailSectionType = 1,
    MembersSectionType = 2,
    AccountDescriptionSectionType = 3
} AccountDetailTableViewSectionType;

typedef enum {
    DetailDateType = 0,
    DetailPayerType = 1,
    DetailConsumerType = 2,
    DetailLocationType = 3
} AccountDetailTableViewRowType;

NSString * const kSegueAccountDetailToMemberList = @"kSegueAccountDetailToMemberList";

NSUInteger const kAccountDetailNumberOfSections = 4;
NSString * const kAccountDetailRowCount = @"kAccountDetailRowCount";
NSString * const kAccountDetailCellIdentifier = @"kAccountDetailCellIdentifier";
NSString * const kAccountDetailCellHeight = @"kAccountDetailCellHeight";
NSString * const kAccountDetailHeaderTitle = @"kAccountDetailHeaderTitle";

@interface MAAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@property (nonatomic, assign) BOOL isShowDateCellPicker;
@property (nonatomic, strong) MAccount *account;

@end

@implementation MAAccountDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isCreateMode = NO;
        self.isShowDateCellPicker = NO;
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    if (self.isCreateMode) {
        [self setEditing:YES animated:NO];
        self.title = @"创建账目";
    } else {
        [self setEditing:NO animated:NO];
        self.title = @"账目详情";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueAccountDetailToMemberList]) {
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow segue - MAAccountDetailViewController");
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self tableView:tableView infoOfSection:indexPath.section row:indexPath.row];
    NSString *cellIdentifier = [rowInfo objectForKey:kAccountDetailCellIdentifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    switch (indexPath.section) {
        case FeeSectionType: {
            MAAccountDetailFeeCell *detailCell = cell;
            detailCell.status = self.isEditing;
            [detailCell reuseCellWithData:self.account];
            break;
        }
        case AccountDetailSectionType: {
            switch (indexPath.row) {
                case DetailDateType: {
                    MAAccountDetailDateCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    detailCell.isDatePickerHidden = !self.isShowDateCellPicker;
                    [detailCell reuseCellWithData:self.account];
                    break;
                }
                case DetailPayerType: {
                    MAAccountDetailPayersCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    [detailCell reuseCellWithData:self.account];
                    break;
                }
                case DetailConsumerType: {
                    MAAccountDetailConsumersCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    [detailCell reuseCellWithData:self.account];
                    break;
                }
                case DetailLocationType: {
                    MAAccountDetailLocationCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    [detailCell reuseCellWithData:self.account];
                    break;
                }
                default:
                    MA_QUICK_ASSERT(NO, @"Unknow row - MAAccountDetailViewController");
            }
            break;
        }
        case MembersSectionType: {
            MAAccountDetailConsumerDetailCell *detailCell = cell;
            detailCell.status = self.isEditing;
            [detailCell reuseCellWithData:self.account];
            break;
        }
        case AccountDescriptionSectionType: {
            MAAccountDetailDescriptionCell *detailCell = cell;
            detailCell.status = self.isEditing;
            [detailCell reuseCellWithData:self.account];
            break;
        }
        default:
            MA_QUICK_ASSERT(NO, @"Unknow section - MAAccountDetailViewController");
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = [self tableView:tableView infoOfSection:section row:0];
    NSInteger rowCount = [[sectionInfo objectForKey:kAccountDetailRowCount] integerValue];

    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kAccountDetailNumberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self tableView:tableView infoOfSection:indexPath.section row:indexPath.row];
    CGFloat rowHeight = [[sectionInfo objectForKey:kAccountDetailCellHeight] floatValue];

    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kAccountDetailSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MAAccountDetailSectionHeader *headerView = [[MAAccountDetailSectionHeader alloc] initWithHeaderTitle:@"未知错误"];

    NSDictionary *sectionInfo = [self tableView:tableView infoOfSection:section row:0];
    [headerView setHeaderTitle:[sectionInfo objectForKey:kAccountDetailHeaderTitle]];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    if (AccountDetailSectionType == indexPath.section &&
        (DetailPayerType == indexPath.row || DetailConsumerType == indexPath.row)) {
        [self performSegueWithIdentifier:kSegueAccountDetailToMemberList sender:nil];
    } else if (AccountDetailSectionType == indexPath.section &&
               DetailDateType == indexPath.row) {
        self.isShowDateCellPicker = !self.isShowDateCellPicker;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

#pragma mark - private

#pragma mark table view control
- (NSDictionary *)tableView:(UITableView *)tableView infoOfSection:(NSInteger)section row:(NSInteger)row
{
    NSInteger rowCount = 0;
    NSString *cellIdentifier = @"";
    CGFloat cellHeight = 0.0f;
    NSString *headerTitle = @"";

    switch (section) {
        case FeeSectionType: {
            headerTitle = @"消费金额";
            rowCount = 1;
            cellIdentifier = [MAAccountDetailFeeCell reuseIdentifier];
            cellHeight = [MAAccountDetailFeeCell cellHeight:@(self.editing)];
            break;
        }
        case AccountDetailSectionType: {
            headerTitle = @"消费信息";
            rowCount = 4;

            switch (row) {
                case DetailDateType: {
                    cellIdentifier = [MAAccountDetailDateCell reuseIdentifier];
                    cellHeight = [MAAccountDetailDateCell cellHeight:@(self.isShowDateCellPicker)];
                    break;
                }
                case DetailPayerType: {
                    cellIdentifier = [MAAccountDetailPayersCell reuseIdentifier];
                    cellHeight = [MAAccountDetailPayersCell cellHeight:@(self.editing)];
                    break;
                }
                case DetailConsumerType: {
                    cellIdentifier = [MAAccountDetailConsumersCell reuseIdentifier];
                    cellHeight = [MAAccountDetailConsumersCell cellHeight:@(self.editing)];
                    break;
                }
                case DetailLocationType: {
                    cellIdentifier = [MAAccountDetailLocationCell reuseIdentifier];
                    cellHeight = [MAAccountDetailLocationCell cellHeight:@(self.editing)];
                    break;
                }
                default:
                    MA_QUICK_ASSERT(NO, @"Unknow row - MAAccountDetailViewController");
            }
            break;
        }
        case MembersSectionType: {
            headerTitle = @"消费伙伴";
            // TODO:
            rowCount = 7;
            cellIdentifier = [MAAccountDetailConsumerDetailCell reuseIdentifier];
            cellHeight = [MAAccountDetailConsumerDetailCell cellHeight:nil];
            break;
        }
        case AccountDescriptionSectionType: {
            headerTitle = @"消费描述";
            rowCount = 1;
            cellIdentifier = [MAAccountDetailDescriptionCell reuseIdentifier];
            cellHeight = [MAAccountDetailDescriptionCell cellHeight:nil];
            break;
        }
        default:
            MA_QUICK_ASSERT(NO, @"Unknow section - MAAccountDetailViewController");
    }

    NSDictionary *info = @{kAccountDetailRowCount : @(rowCount),
                           kAccountDetailCellIdentifier : cellIdentifier,
                           kAccountDetailCellHeight : @(cellHeight),
                           kAccountDetailHeaderTitle : headerTitle};
    return info;
}

#pragma mark property method
- (UIBarButtonItem *)cancelBarItem
{
    if (_cancelBarItem) {
        return _cancelBarItem;
    }

    _cancelBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelButtonTaped:)];
    return _cancelBarItem;
}

#pragma mark UI action
- (void)didCancelButtonTaped:(UIBarButtonItem *)sender
{
    if (self.editing) {
        MAAlertView *alert = nil;
        if (self.isCreateMode) {
            alert = [MAAlertView alertWithTitle:@"确认放弃创建么？"
                                        message:nil
                                   buttonTitle1:@"放弃创建"
                                   buttonBlock1:^{
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }
                                   buttonTitle2:@"点错了~"
                                   buttonBlock2:nil];
        } else {
            alert = [MAAlertView alertWithTitle:@"确认放弃更改么？"
                                        message:nil
                                   buttonTitle1:@"放弃更改"
                                   buttonBlock1:^{
                                       [self setEditing:NO animated:YES];
                                   }
                                   buttonTitle2:@"点错了~"
                                   buttonBlock2:nil];
        }
        [alert show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
    } else {
        if (self.isCreateMode) {
            // TODO:
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationItem setHidesBackButton:NO animated:YES];
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        }
        self.isShowDateCellPicker = NO;
    }

    NSRange range;
    range.location = 0;
    range.length = kAccountDetailNumberOfSections;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
}

@end