//
//  MAMemberDetailViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAMemberDetailViewController.h"

#import "MAMemberDetailCommonCell.h"
#import "MAMemberDetailGenderCell.h"
#import "MAMemberDetailBirthdayCell.h"
#import "MMember.h"

NSUInteger const kMemberDetailRowCount = 5;
NSString * const kMemberDetailRowType = @"kMemberDetailRowType";
NSString * const kMemberDetailCellIdentifier = @"kMemberDetailCellIdentifier";
NSString * const kMemberDetailCellHeight = @"kMemberDetailCellHeight";

typedef enum {
    MAMemberDetailListTypeName = 0,
    MAMemberDetailListTypeGender = 1,
    MAMemberDetailListTypeTelephone = 2,
    MAMemberDetailListTypeEMail = 3,
    MAMemberDetailListTypeBirthday = 4
} MAMemberDetailListType;

@interface MAMemberDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@end

@implementation MAMemberDetailViewController

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

    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
    if (self.isCreateMode) {
        [self setEditing:YES animated:NO];
        self.title = @"创建新成员";
    } else {
        [self setEditing:NO animated:NO];
        self.title = @"成员信息";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self tableView:tableView infoOfRow:indexPath.row];

    NSString *cellIdentifier = [rowInfo objectForKey:kMemberDetailCellIdentifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    MAMemberDetailListType rowType = [[rowInfo objectForKey:kMemberDetailRowType] integerValue];
    switch (rowType) {
        case MAMemberDetailListTypeName: {
            MAMemberDetailCommonCell *detailCell = cell;
            [detailCell setTitle:@"姓名：" detail:@"李某某"];
            detailCell.status = self.isEditing;
            detailCell.keyboardType = UIKeyboardTypeDefault;
            [detailCell reuseCellWithData:self.member];
            break;
        }
        case MAMemberDetailListTypeGender: {
            MAMemberDetailGenderCell *detailCell = cell;
            detailCell.status = self.isEditing;
            [detailCell reuseCellWithData:self.member];
            break;
        }
        case MAMemberDetailListTypeTelephone: {
            MAMemberDetailCommonCell *detailCell = cell;
            [detailCell setTitle:@"电话：" detail:@"12345678901"];
            detailCell.status = self.isEditing;
            detailCell.keyboardType = UIKeyboardTypeNumberPad;
            [detailCell reuseCellWithData:self.member];
            break;
        }
        case MAMemberDetailListTypeEMail: {
            MAMemberDetailCommonCell *detailCell = cell;
            [detailCell setTitle:@"邮箱：" detail:@"zhuocheng.lee@gmail.com"];
            detailCell.status = self.isEditing;
            detailCell.keyboardType = UIKeyboardTypeEmailAddress;
            [detailCell reuseCellWithData:self.member];
            break;
        }
        case MAMemberDetailListTypeBirthday: {
            MAMemberDetailBirthdayCell *detailCell = cell;
            detailCell.status = self.isEditing;
            [detailCell reuseCellWithData:self.member];
            break;
        }
        default:
            NSAssert(NO, @"Wrong row number in table view, infoOfRow!");
            break;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kMemberDetailRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self tableView:tableView infoOfRow:indexPath.row];

    CGFloat rowHeight = [[rowInfo objectForKey:kMemberDetailCellHeight] floatValue];
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (NSDictionary *)tableView:(UITableView *)tableView infoOfRow:(NSInteger)row
{
    MAMemberDetailListType rowType = MAMemberDetailListTypeName;
    CGFloat rowHeight = 0.0f;
    NSString *cellIdentifier = @"";

    switch (row) {
        case MAMemberDetailListTypeName: {
            rowType = MAMemberDetailListTypeName;
            rowHeight = [MAMemberDetailCommonCell cellHeight:nil];
            cellIdentifier = [MAMemberDetailCommonCell className];
            break;
        }
        case MAMemberDetailListTypeGender: {
            rowType = MAMemberDetailListTypeGender;
            rowHeight = [MAMemberDetailGenderCell cellHeight:nil];
            cellIdentifier = [MAMemberDetailGenderCell className];
            break;
        }
        case MAMemberDetailListTypeTelephone: {
            rowType = MAMemberDetailListTypeTelephone;
            rowHeight = [MAMemberDetailCommonCell cellHeight:nil];
            cellIdentifier = [MAMemberDetailCommonCell className];
            break;
        }
        case MAMemberDetailListTypeEMail: {
            rowType = MAMemberDetailListTypeEMail;
            rowHeight = [MAMemberDetailCommonCell cellHeight:nil];
            cellIdentifier = [MAMemberDetailCommonCell className];
            break;
        }
        case MAMemberDetailListTypeBirthday: {
            rowType = MAMemberDetailListTypeBirthday;
            rowHeight = [MAMemberDetailBirthdayCell cellHeight:@(self.isEditing)];
            cellIdentifier = [MAMemberDetailBirthdayCell className];
            break;
        }
        default:
            NSAssert(NO, @"Wrong row number in table view, infoOfRow!");
            break;
    }

    return @{kMemberDetailRowType:@(rowType),
             kMemberDetailCellHeight:@(rowHeight),
             kMemberDetailCellIdentifier:cellIdentifier};
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
        NSAssert(NO, @"Wrong state, (didCancelButtonTaped:)");
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    if (editing) {
        [self.accountButton setHidden:YES];
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
    } else {
        [self.accountButton setHidden:NO];
        if (self.isCreateMode) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationItem setHidesBackButton:NO animated:YES];
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        }
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end