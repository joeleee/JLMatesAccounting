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

NSUInteger const kNumberOfSections = 4;
NSString * const kTableInfoRowCount = @"kTableInfoRowCount";
NSString * const kTableInfoSectionType = @"kTableInfoSectionType";
NSString * const kTableInfoCellIdentifier = @"kTableInfoCellIdentifier";
NSString * const kTableInfoCellHeight = @"kTableInfoCellHeight";
NSString * const kTableInfoHeaderTitle = @"kTableInfoHeaderTitle";

@interface MAAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation MAAccountDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.datePicker setHidden:YES];
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
            cellIdentifier = [MAAccountDetailFeeCell className];
            cellHeight = [MAAccountDetailFeeCell cellHeight:nil];
            break;
        }
        case 1: {
            headerTitle = @"消费信息";
            sectionType = AccountDetailSectionType;
            rowCount = 4;

            switch (row) {
                case 0: {
                    cellIdentifier = [MAAccountDetailDateCell className];
                    cellHeight = [MAAccountDetailDateCell cellHeight:nil];
                    break;
                }
                case 1: {
                    cellIdentifier = [MAAccountDetailPayersCell className];
                    cellHeight = [MAAccountDetailPayersCell cellHeight:nil];
                    break;
                }
                case 2: {
                    cellIdentifier = [MAAccountDetailConsumersCell className];
                    cellHeight = [MAAccountDetailConsumersCell cellHeight:nil];
                    break;
                }
                case 3: {
                    cellIdentifier = [MAAccountDetailLocationCell className];
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
            cellIdentifier = [MAAccountDetailConsumerDetailCell className];
            cellHeight = [MAAccountDetailConsumerDetailCell cellHeight:nil];
            break;
        }
        case 3: {
            headerTitle = @"消费描述";
            sectionType = AccountDescriptionSectionType;
            rowCount = 1;
            cellIdentifier = [MAAccountDetailDescriptionCell className];
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

@end