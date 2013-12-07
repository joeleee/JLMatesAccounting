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

typedef enum {
    FeeSectionType = 0,
    AccountDetailSectionType = 1,
    MembersSectionType = 2,
    AccountDescriptionSectionType = 3
} AccountDetailTableViewSectionType;

NSString * const kSegueAccountDetailToMemberList = @"kSegueAccountDetailToMemberList";

NSUInteger const kNumberOfSections = 4;
NSString * const kTableInfoRowCount = @"kTableInfoRowCount";
NSString * const kTableInfoSectionType = @"kTableInfoSectionType";
NSString * const kTableInfoCellIdentifier = @"kTableInfoCellIdentifier";
NSString * const kTableInfoCellHeight = @"kTableInfoCellHeight";
NSString * const kTableInfoHeaderTitle = @"kTableInfoHeaderTitle";

@interface MAAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@property (nonatomic, assign) BOOL isCreateMode;

@end

@implementation MAAccountDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isCreateMode = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setLeftBarButtonItem:self.cancelBarItem];
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    if (self.isCreateMode) {
        [self setEditing:YES animated:NO];
    }
    [self.datePicker setHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self tableView:tableView InfoOfSection:indexPath.section row:indexPath.row];

    NSString *cellIdentifier = [sectionInfo objectForKey:kTableInfoCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionInfo = [self tableView:tableView InfoOfSection:section row:0];
    NSInteger rowCount = [[sectionInfo objectForKey:kTableInfoRowCount] integerValue];

    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kNumberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self tableView:tableView InfoOfSection:indexPath.section row:indexPath.row];
    CGFloat rowHeight = [[sectionInfo objectForKey:kTableInfoCellHeight] floatValue];

    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kAccountDetailSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MAAccountDetailSectionHeader *headerView = [[MAAccountDetailSectionHeader alloc] initWithHeaderTitle:@"未知错误"];

    NSDictionary *sectionInfo = [self tableView:tableView InfoOfSection:section row:0];
    [headerView setHeaderTitle:[sectionInfo objectForKey:kTableInfoHeaderTitle]];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSegueAccountDetailToMemberList sender:nil];
}

#pragma mark - private

#pragma mark table view control
- (NSDictionary *)tableView:(UITableView *)tableView InfoOfSection:(NSInteger)section row:(NSInteger)row
{
    AccountDetailTableViewSectionType sectionType = 0;
    NSInteger rowCount = 0;
    NSString *cellIdentifier = @"";
    CGFloat cellHeight = 0.0f;
    NSString *headerTitle = @"";

    switch (section) {
        case 0: {
            headerTitle = @"消费金额";
            sectionType = FeeSectionType;
            rowCount = 1;
            cellIdentifier = [MAAccountDetailFeeCell reuseIdentifier];
            cellHeight = [MAAccountDetailFeeCell cellHeight:nil];
            break;
        }
        case 1: {
            headerTitle = @"消费信息";
            sectionType = AccountDetailSectionType;
            rowCount = 4;

            switch (row) {
                case 0: {
                    cellIdentifier = [MAAccountDetailDateCell reuseIdentifier];
                    cellHeight = [MAAccountDetailDateCell cellHeight:nil];
                    break;
                }
                case 1: {
                    cellIdentifier = [MAAccountDetailPayersCell reuseIdentifier];
                    cellHeight = [MAAccountDetailPayersCell cellHeight:nil];
                    break;
                }
                case 2: {
                    cellIdentifier = [MAAccountDetailConsumersCell reuseIdentifier];
                    cellHeight = [MAAccountDetailConsumersCell cellHeight:nil];
                    break;
                }
                case 3: {
                    cellIdentifier = [MAAccountDetailLocationCell reuseIdentifier];
                    cellHeight = [MAAccountDetailLocationCell cellHeight:nil];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            headerTitle = @"消费伙伴";
            sectionType = MembersSectionType;
            // TODO:
            rowCount = 7;
            cellIdentifier = [MAAccountDetailConsumerDetailCell reuseIdentifier];
            cellHeight = [MAAccountDetailConsumerDetailCell cellHeight:nil];
            break;
        }
        case 3: {
            headerTitle = @"消费描述";
            sectionType = AccountDescriptionSectionType;
            rowCount = 1;
            cellIdentifier = [MAAccountDetailDescriptionCell reuseIdentifier];
            cellHeight = [MAAccountDetailDescriptionCell cellHeight:nil];
            break;
        }
        default:
            break;
    }

    NSDictionary *info = @{kTableInfoSectionType : @(sectionType),
                           kTableInfoRowCount : @(rowCount),
                           kTableInfoCellIdentifier : cellIdentifier,
                           kTableInfoCellHeight : @(cellHeight),
                           kTableInfoHeaderTitle : headerTitle};
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
                                       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView reloadData];
}

@end