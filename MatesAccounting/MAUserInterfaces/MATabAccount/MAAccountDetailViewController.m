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
#import "MAAccountDetailDeleteCell.h"
#import "MAAccountDetailSectionHeader.h"
#import "MAccount+expand.h"
#import "UIViewController+MAAddition.h"
#import "MPlace.h"
#import "MAAccountManager.h"
#import "MFriend.h"
#import "MAMemberListViewController.h"
#import "MALocationManager.h"
#import "MAGroupManager.h"

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

NSString *const kSegueAccountDetailToMemberList = @"kSegueAccountDetailToMemberList";

NSUInteger const kAccountDetailNumberOfSections = 4;
NSString *const  kAccountDetailRowCount = @"kAccountDetailRowCount";
NSString *const  kAccountDetailCellIdentifier = @"kAccountDetailCellIdentifier";
NSString *const  kAccountDetailCellHeight = @"kAccountDetailCellHeight";
NSString *const  kAccountDetailHeaderTitle = @"kAccountDetailHeaderTitle";

@interface MAAccountDetailViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate, MAMemberListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@property (nonatomic, assign) BOOL isShowDateCellPicker;
@property (nonatomic, strong) MAccount *account;
@property (nonatomic, strong) MGroup *group;
@property (nonatomic, strong) NSArray *payers;
@property (nonatomic, strong) NSArray *consumers;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) NSIndexPath *registKeyboardIndexPath;

@property (nonatomic, strong) NSDecimalNumber *editingTotalFee;
@property (nonatomic, strong) NSDate *editingDate;
@property (nonatomic, copy) NSString *editingPlaceName;
@property (nonatomic, strong) CLLocation *editingLocation;
@property (nonatomic, copy) NSString *editingDetail;
@property (nonatomic, strong) NSMutableArray *editingPayers;
@property (nonatomic, strong) NSMutableArray *editingConsumers;

@end

@implementation MAAccountDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isShowDateCellPicker = NO;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];

    if (!self.group && !self.account) {
        [MBProgressHUD showTextHUDOnView:[[UIApplication sharedApplication].delegate window]
                                    text:@"Empty group, can not create account!"
                         completionBlock:^{
                             [self disappear:YES];
                         }
                                animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    MA_HIDE_KEYBOARD;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[MALocationManager sharedManager] stopLocationWithKey:self.className];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];

    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.clipsToBounds = NO;

    if (self.account) {
        [self setEditing:NO animated:NO];
        self.title = @"Account";
    } else {
        [self setEditing:YES animated:NO];
        self.title = @"Create Account";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueAccountDetailToMemberList]) {
        MAMemberListViewController *memberListViewController = [(UINavigationController *)(segue.destinationViewController) viewControllers][0];
        NSIndexPath *indexPath = sender;
        NSArray *selectedFeeOfMembers;
        if (AccountDetailSectionType == indexPath.section && DetailPayerType == indexPath.row) {
            selectedFeeOfMembers = self.editingPayers;
            memberListViewController.userInfo[kSegueAccountDetailToMemberList] = @(DetailPayerType);
        } else if (AccountDetailSectionType == indexPath.section && DetailConsumerType == indexPath.row) {
            selectedFeeOfMembers = self.editingConsumers;
            memberListViewController.userInfo[kSegueAccountDetailToMemberList] = @(DetailConsumerType);
        } else {
            MA_QUICK_ASSERT(NO, @"Unknow sender - MAAccountDetailViewController");
        }
        NSMutableOrderedSet *members = [NSMutableOrderedSet orderedSet];
        for (MAFeeOfMember *feeOfMember in selectedFeeOfMembers) {
            [members addObject:feeOfMember.member];
        }
        [memberListViewController setGroup:self.group selectedMembers:members.array delegate:self];
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow segue - MAAccountDetailViewController");
    }
}

- (void)loadData
{
    if (self.isEditing) {
        self.payers = self.editingPayers;
        self.consumers = self.editingConsumers;
        self.placeName = self.editingPlaceName;
        self.location = self.editingLocation;
    } else {
        self.payers = [AccountManager feeOfMembersForAccount:self.account isPayers:YES];
        self.consumers = [AccountManager feeOfMembersForAccount:self.account isPayers:NO];
        self.placeName = self.account.place.placeName;
        self.location = self.account.place.location;
    }

    NSRange range;
    range.location = 0;
    range.length = kAccountDetailNumberOfSections;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)clearEditingData
{
    self.editingTotalFee = DecimalZero;
    self.editingDate = nil;
    self.editingPlaceName = nil;
    self.editingLocation = nil;
    self.editingDetail = nil;
    self.editingPayers = nil;
    self.editingConsumers = nil;
}

- (void)refreshEditingData
{
    if (self.account) {
        self.editingTotalFee = self.account.totalFee;
        self.editingDate = self.account.accountDate;
        self.editingPlaceName = self.account.place.placeName;
        self.editingLocation = self.account.place.location;
        self.editingDetail = self.account.detail;
        self.editingPayers = [NSMutableArray arrayWithArray:self.payers];
        self.editingConsumers = [NSMutableArray arrayWithArray:self.consumers];
    } else {
        self.editingTotalFee = DecimalZero;
        self.editingDate = [NSDate date];
        self.editingPayers = nil;
        self.editingConsumers = nil;
        self.editingPlaceName = @"locating...";
        self.editingLocation = nil;
        self.editingDetail = nil;
        __weak typeof(self) weakSelf = self;
        [[MALocationManager sharedManager] locationByExpirationMinute:3 key:self.className onCompletion:^(CLLocation *location) {
            [weakSelf didFinishedLocationing:location error:nil];
        } onFailed:^(NSError *error) {
            [weakSelf didFinishedLocationing:nil error:error];
        }];
    }
}

- (void)didFinishedLocationing:(CLLocation *)location error:(NSError *)error
{
    if (!self.isEditing) {
        return;
    }

    if (error || !location) {
    } else {
        self.editingLocation = location;
        self.editingPlaceName = [NSString stringWithFormat:@"%.4f, %.4f", location.coordinate.longitude, location.coordinate.latitude];
    }
    [self.tableView reloadData];
}

- (NSDictionary *)tableView:(UITableView *)tableView infoOfSection:(NSInteger)section row:(NSInteger)row
{
    NSInteger rowCount = 0;
    NSString  *cellIdentifier = @"";
    CGFloat   cellHeight = 0.0f;
    NSString  *headerTitle = @"";

    switch (section) {
        case FeeSectionType:
        {
            headerTitle = @"Total coast";
            rowCount = 1;
            cellIdentifier = [MAAccountDetailFeeCell className];
            cellHeight = [MAAccountDetailFeeCell cellHeight:@(self.editing)];
            break;
        }

        case AccountDetailSectionType:
        {
            headerTitle = @"Account info";
            rowCount = 4;

            switch (row) {
                case DetailDateType:
                {
                    cellIdentifier = [MAAccountDetailDateCell className];
                    cellHeight = [MAAccountDetailDateCell cellHeight:@(self.isShowDateCellPicker)];
                    break;
                }

                case DetailPayerType:
                {
                    cellIdentifier = [MAAccountDetailPayersCell className];
                    cellHeight = [MAAccountDetailPayersCell cellHeight:@(self.editing)];
                    break;
                }

                case DetailConsumerType:
                {
                    cellIdentifier = [MAAccountDetailConsumersCell className];
                    cellHeight = [MAAccountDetailConsumersCell cellHeight:@(self.editing)];
                    break;
                }

                case DetailLocationType:
                {
                    cellIdentifier = [MAAccountDetailLocationCell className];
                    cellHeight = [MAAccountDetailLocationCell cellHeight:@(self.editing)];
                    break;
                }

                default:
                    MA_QUICK_ASSERT(NO, @"Unknow row - MAAccountDetailViewController");
            }
            break;
        }

        case MembersSectionType:
        {
            headerTitle = @"Consumer details";
            if (self.isEditing) {
                rowCount = self.editingPayers.count + self.editingConsumers.count;
            } else {
                rowCount = self.payers.count + self.consumers.count;
            }

            cellIdentifier = [MAAccountDetailConsumerDetailCell className];
            cellHeight = [MAAccountDetailConsumerDetailCell cellHeight:nil];
            break;
        }

        case AccountDescriptionSectionType:
        {
            headerTitle = @"Description";
            rowCount = 1;
            if (self.isEditing && self.account) {
                ++rowCount;
            }

            switch (row) {
                case 0: {
                    cellIdentifier = [MAAccountDetailDescriptionCell className];
                    cellHeight = [MAAccountDetailDescriptionCell cellHeight:nil];
                } break;
                case 1: {
                    cellIdentifier = [MAAccountDetailDeleteCell className];
                    cellHeight = [MAAccountDetailDeleteCell cellHeight:nil];
                } break;
                default:
                    break;
            }
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

#pragma mark - notification actions

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets newContentInset = self.tableView.contentInset;
    newContentInset.bottom = keyboardFrame.size.height;
    self.tableView.contentInset = newContentInset;

    if (self.registKeyboardIndexPath) {
        [self.tableView scrollToRowAtIndexPath:self.registKeyboardIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    UIEdgeInsets newContentInset = self.tableView.contentInset;
    newContentInset.bottom = 0.0f;
    self.tableView.contentInset = newContentInset;
    self.registKeyboardIndexPath = nil;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self tableView:tableView infoOfSection:indexPath.section row:indexPath.row];
    NSString     *cellIdentifier = [rowInfo objectForKey:kAccountDetailCellIdentifier];
    id           cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    switch (indexPath.section) {
        case FeeSectionType:
        {
            MAAccountDetailFeeCell *detailCell = cell;
            detailCell.status = self.isEditing;
            NSDecimalNumber *fee = self.isEditing ? self.editingTotalFee : self.account.totalFee;
            [detailCell reuseCellWithData:(NSOrderedSame != [fee compare:DecimalZero]) ? [fee description] : nil];
            detailCell.actionDelegate = self;
            break;
        }

        case AccountDetailSectionType:
        {
            switch (indexPath.row) {
                case DetailDateType:
                {
                    MAAccountDetailDateCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    detailCell.actionDelegate = self;
                    [detailCell setDatePickerHidden:!self.isShowDateCellPicker];
                    [detailCell reuseCellWithData:self.isEditing ? self.editingDate : self.account.accountDate];
                    break;
                }

                case DetailPayerType:
                {
                    MAAccountDetailPayersCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    NSArray *payers = self.isEditing ? self.editingPayers : self.payers;
                    NSString *memberDescription = ((MAFeeOfMember *)payers.firstObject).member.name;
                    for (NSUInteger index = 0; index < payers.count; ++index) {
                        memberDescription = [NSString stringWithFormat:@"%@, %@", memberDescription, ((MAFeeOfMember *)payers[index]).member.name];
                    }
                    [detailCell reuseCellWithData:memberDescription ? memberDescription : @"tap to choice..."];
                    break;
                }

                case DetailConsumerType:
                {
                    MAAccountDetailConsumersCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    NSArray *consumers = self.isEditing ? self.editingConsumers : self.consumers;
                    NSString *memberDescription = ((MAFeeOfMember *)consumers.firstObject).member.name;
                    for (NSUInteger index = 0; index < consumers.count; ++index) {
                        memberDescription = [NSString stringWithFormat:@"%@, %@", memberDescription, ((MAFeeOfMember *)consumers[index]).member.name];
                    }
                    [detailCell reuseCellWithData:memberDescription ? memberDescription : @"tap to choice..."];
                    break;
                }

                case DetailLocationType:
                {
                    MAAccountDetailLocationCell *detailCell = cell;
                    detailCell.status = self.isEditing;
                    [detailCell reuseCellWithData:self.isEditing ? self.editingPlaceName : self.placeName];
                    break;
                }

                default:
                    MA_QUICK_ASSERT(NO, @"Unknow row - MAAccountDetailViewController");
            }
            break;
        }

        case MembersSectionType:
        {
            MAAccountDetailConsumerDetailCell *detailCell = cell;
            detailCell.actionDelegate = self;
            NSUInteger index = indexPath.row;
            MAFeeOfMember *data = nil;
            NSArray *payers = self.isEditing ? self.editingPayers : self.payers;
            NSArray *consumers = self.isEditing ? self.editingConsumers : self.consumers;
            if (index < payers.count) {
                data = payers[index];
            } else if ((index - payers.count) < consumers.count) {
                data = consumers[index - payers.count];
            }
            detailCell.status = self.isEditing && [GroupManager isMember:data.member belongsToGroup:self.group];
            [detailCell reuseCellWithData:data];
            break;
        }

        case AccountDescriptionSectionType:
        {
            MABaseCell *detailCell = cell;
            detailCell.status = self.isEditing;
            detailCell.actionDelegate = self;
            [detailCell reuseCellWithData:self.isEditing ? self.editingDetail : self.account.detail];
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
    NSInteger    rowCount = [[sectionInfo objectForKey:kAccountDetailRowCount] integerValue];

    return rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kAccountDetailNumberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionInfo = [self tableView:tableView infoOfSection:indexPath.section row:indexPath.row];
    CGFloat      rowHeight = [[sectionInfo objectForKey:kAccountDetailCellHeight] floatValue];

    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0;
    } else {
        return kAccountDetailSectionHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }

    MAAccountDetailSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MAAccountDetailSectionHeader className]];
    if (!headerView) {
        headerView = [[MAAccountDetailSectionHeader alloc] initWithReuseIdentifier:[MAAccountDetailSectionHeader className]];
    }

    NSDictionary *sectionInfo = [self tableView:tableView infoOfSection:section row:0];
    [headerView reuseWithHeaderTitle:[sectionInfo objectForKey:kAccountDetailHeaderTitle]];

    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_HIDE_KEYBOARD;

    if (!self.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    if ((AccountDetailSectionType == indexPath.section) &&
        ((DetailPayerType == indexPath.row) || (DetailConsumerType == indexPath.row))) {
        [self performSegueWithIdentifier:kSegueAccountDetailToMemberList sender:indexPath];
    } else if ((AccountDetailSectionType == indexPath.section) &&
               (DetailDateType == indexPath.row)) {
        self.isShowDateCellPicker = !self.isShowDateCellPicker;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark MACellActionDelegate

- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    BOOL shouldScroll = NO;

    if ([cell isKindOfClass:MAAccountDetailFeeCell.class]) {
        if (0 == type) {
            shouldScroll = YES;
        } else if (1 == type) {
            NSString *feeText = [(UILabel *)data text];
            self.editingTotalFee = [NSDecimalNumber decimalNumberWithString:feeText];
            if ([self.editingTotalFee isEqualToNumber:[NSDecimalNumber notANumber]]) {
                self.editingTotalFee = DecimalZero;
            }
            if (NSOrderedSame == [self.editingTotalFee compare:DecimalZero]) {
                [(UILabel *)data setText:nil];
            }
        }
    } else if ([cell isKindOfClass:MAAccountDetailDateCell.class]) {
        if (self.isShowDateCellPicker) {
            self.editingDate = [(UIDatePicker *)data date];
        }
    } else if ([cell isKindOfClass:MAAccountDetailConsumerDetailCell.class]) {
        if (0 == type) {
            shouldScroll = YES;
        } else if (1 == type) {
            NSString *feeText = [(UILabel *)data text];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            BOOL isPayer = indexPath.row < self.editingPayers.count;
            MAFeeOfMember *feeOfMember = isPayer ? self.editingPayers[indexPath.row] : self.editingConsumers[indexPath.row - self.editingPayers.count];
            NSDecimalNumber *fee = [NSDecimalNumber decimalNumberWithString:feeText];
            if ([fee isEqualToNumber:[NSDecimalNumber notANumber]]) {
                fee = DecimalZero;
            }
            if ((isPayer && NSOrderedAscending == [fee compare:DecimalZero]) ||
                (!isPayer && NSOrderedDescending == [fee compare:DecimalZero])) {
                fee = [fee decimalNumberByMultiplyingBy:MAIntegerDecimal(-1)];
            }
            feeOfMember.fee = fee;
            if (NSOrderedSame == [feeOfMember.fee compare:DecimalZero]) {
                [(UILabel *)data setText:@""];
            } else {
                [(UILabel *)data setText:[feeOfMember.fee description]];
            }
            [self.tableView reloadData];
        }
    } else if ([cell isKindOfClass:MAAccountDetailDescriptionCell.class]) {
        if (0 == type) {
            shouldScroll = YES;
        } else if (1 == type) {
            self.editingDetail = [(UITextView *)data text];
        }
    } else if ([cell isKindOfClass:MAAccountDetailDeleteCell.class]) {
        [[MAAlertView alertWithTitle:@"Confirm"
                             message:@"Deleted account can not be recovered."
                        buttonTitle1:@"Cancel"
                        buttonBlock1:^{
                        }
                        buttonTitle2:@"Delete"
                        buttonBlock2:^{
                            [AccountManager deleteAccount:self.account onComplete:^(id result, NSError *error) {
                                [self disappear:YES];
                            } onFailed:^(id result, NSError *error) {
                                [[MAAlertView alertWithTitle:@"Delete Failed" message:error.domain buttonTitle:@"OK" buttonBlock:^{ }] show];
                            }];
                        }]
         show];
    }

    if (shouldScroll) {
        self.registKeyboardIndexPath = [self.tableView indexPathForCell:cell];
        [self.tableView scrollToRowAtIndexPath:self.registKeyboardIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    return YES;
}

#pragma mark MAMemberListViewControllerDelegate

- (void)memberListController:(MAMemberListViewController *)sender didFinishedSelectMember:(NSArray *)selectedMembers
{
    switch ([sender.userInfo[kSegueAccountDetailToMemberList] integerValue]) {

        case DetailPayerType: {
            NSArray *editingPayers = [AccountManager feeOfMembersForNewMembers:selectedMembers originFeeOfMembers:self.editingPayers totalFee:self.editingTotalFee isPayer:YES inGroup:self.group];
            self.editingPayers = [NSMutableArray arrayWithArray:editingPayers];
        } break;

        case DetailConsumerType: {
            NSArray *editingConsumers = [AccountManager feeOfMembersForNewMembers:selectedMembers originFeeOfMembers:self.editingConsumers totalFee:self.editingTotalFee isPayer:NO inGroup:self.group];
            self.editingConsumers = [NSMutableArray arrayWithArray:editingConsumers];
        } break;

        default: {
            MA_QUICK_ASSERT(NO, @"Wrong userInfo");
        } break;
    }
    [self.tableView reloadData];
}

#pragma mark - property method

- (UIBarButtonItem *)cancelBarItem
{
    if (_cancelBarItem) {
        return _cancelBarItem;
    }

    _cancelBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelButtonTaped:)];
    return _cancelBarItem;
}

#pragma mark UI action

- (void)didEditButtonTaped:(UIBarButtonItem *)sender
{
    [self setEditing:YES animated:YES];
}

- (void)didSaveButtonTaped:(UIBarButtonItem *)sender
{
    MA_HIDE_KEYBOARD;
    if (0 >= self.editingPayers.count || 0 >= self.editingConsumers.count) {
        [[MAAlertView alertWithTitle:nil message:@"Payers or Consumers can't be null." buttonTitle:@"OK" buttonBlock:^{ }] show];
        return;
    }

    if (NSOrderedSame == [self.editingTotalFee compare:DecimalZero]) {
        [[MAAlertView alertWithTitle:nil message:@"Total fee can't be '0'." buttonTitle:@"OK" buttonBlock:^{ }] show];
        return;
    }

    NSMutableSet *feeOfMambers = [NSMutableSet setWithArray:self.editingPayers];
    [feeOfMambers addObjectsFromArray:self.editingConsumers];

    // verify total fee
    NSDecimalNumber *sumFee = DecimalZero;
    NSDecimalNumber *totalFee = DecimalZero;
    for (MAFeeOfMember *feeOfMember in feeOfMambers) {
        if (NSOrderedDescending == [feeOfMember.fee compare:DecimalZero]) {
            totalFee = [totalFee decimalNumberByAdding:feeOfMember.fee];
        }
        sumFee = [sumFee decimalNumberByAdding:feeOfMember.fee];
    }
    NSString *errorText = (NSOrderedSame != [sumFee compare:DecimalZero]) ? @"Spending ≠ Income." : ((NSOrderedSame != [[self.editingTotalFee decimalNumberByAdding:[totalFee inverseNumber]] compare:DecimalZero]) ? @"Total fee is invalid." : nil);
    if (errorText) {
        [[MAAlertView alertWithTitle:nil message:errorText buttonTitle:@"OK" buttonBlock:nil] show];
        return;
    }

    if (self.account) { // not create mode
        BOOL updated = [AccountManager updateAccount:self.account
                                                date:self.editingDate
                                           placeName:self.editingPlaceName
                                            location:self.editingLocation
                                              detail:self.editingDetail
                                        feeOfMembers:feeOfMambers];

        if (updated) {
            [self setEditing:NO animated:YES];
        } else {
            [[MAAlertView alertWithTitle:@"Update Failed!" message:nil buttonTitle:@"OK" buttonBlock:^{ }] show];
        }
    } else { // create mode
        self.account = [AccountManager createAccountWithGroup:self.group
                                                         date:self.editingDate
                                                    placeName:self.editingPlaceName
                                                     location:self.editingLocation
                                                       detail:self.editingDetail
                                                 feeOfMembers:feeOfMambers];

        if (self.account) {
            [self setEditing:NO animated:YES];
            [self disappear:YES];
        } else {
            [[MAAlertView alertWithTitle:@"Create Failed!" message:nil buttonTitle:@"OK" buttonBlock:^{ }] show];
        }
    }
}

- (void)didCancelButtonTaped:(UIBarButtonItem *)sender
{
    if (self.editing) {
        if (self.account) {
            [self clearEditingData];
            [self setEditing:NO animated:YES];
        } else {
            [self clearEditingData];
            [self disappear:YES];
        }
    } else {
        MA_QUICK_ASSERT(NO, @"Wrong state, (didCancelButtonTaped:)");
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    if (editing) {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSaveButtonTaped:)] animated:YES];
        [self refreshEditingData];
    } else {
        self.isShowDateCellPicker = NO;
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didEditButtonTaped:)] animated:YES];
        [self clearEditingData];
    }
    
    [self loadData];
}

#pragma mark - Public Method

- (void)setAccount:(MAccount *)account
{
    if (_account == account) {
        return;
    }

    [self willChangeValueForKey:@"account"];
    _account = account;
    [self didChangeValueForKey:@"account"];
    _group = _account.group;
}

- (void)setGroup:(MGroup *)group
{
    if (_group == group) {
        return;
    }

    [self willChangeValueForKey:@"group"];
    _group = group;
    [self didChangeValueForKey:@"group"];
    _account = nil;
}

@end