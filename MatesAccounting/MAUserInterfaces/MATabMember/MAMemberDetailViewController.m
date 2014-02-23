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
#import "MFriend.h"
#import "MAFriendManager.h"

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

@interface MAMemberDetailViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@property (nonatomic, copy) NSString *editingName;
@property (nonatomic, assign) MAGenderEnum editingGender;
@property (nonatomic, copy) NSString *editingPhone;
@property (nonatomic, copy) NSString *editingMail;
@property (nonatomic, strong) NSDate *editingBirthday;

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

- (void)clearEditingData
{
    self.editingName = nil;
    self.editingGender = MAGenderUnknow;
    self.editingPhone = nil;
    self.editingMail = nil;
    self.editingBirthday = nil;
}

- (void)refreshEditingData
{
    self.editingName = self.member.name ? self.member.name : @"";
    self.editingGender = [self.member.sex integerValue];
    self.editingPhone = [self.member.telephoneNumber stringValue];
    self.editingMail = self.member.eMail ? self.member.eMail : @"";
    self.editingBirthday = self.member.birthday;
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
            detailCell.actionDelegate = self;
            detailCell.status = self.isEditing;
            detailCell.tag = MAMemberDetailListTypeName;
            NSString *name = nil;
            if (self.isEditing) {
                name = self.editingName;
            } else {
                name = self.member.name;
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"姓名：",
                                       kMemberDetailCellContent:name ? name : @"",
                                       kMemberDetailCellKeyboardType:@(UIKeyboardTypeDefault)};
            [detailCell reuseCellWithData:cellInfo];
            break;
        }

        case MAMemberDetailListTypeGender: {
            MAMemberDetailGenderCell *detailCell = cell;
            detailCell.actionDelegate = self;
            detailCell.status = self.isEditing;
            detailCell.tag = MAMemberDetailListTypeGender;
            if (self.isEditing) {
                [detailCell reuseCellWithData:@(self.editingGender)];
            } else {
                [detailCell reuseCellWithData:self.member.sex];
            }
            break;
        }

        case MAMemberDetailListTypeTelephone: {
            MAMemberDetailCommonCell *detailCell = cell;
            detailCell.actionDelegate = self;
            detailCell.status = self.isEditing;
            detailCell.tag = MAMemberDetailListTypeTelephone;
            NSString *phoneString = nil;
            if (self.isEditing) {
                phoneString = self.editingPhone;
            } else {
                phoneString = [self.member.telephoneNumber stringValue];
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"电话：",
                                       kMemberDetailCellContent:phoneString ? phoneString : @"",
                                       kMemberDetailCellKeyboardType:@(UIKeyboardTypeNumberPad)};
            [detailCell reuseCellWithData:cellInfo];
            break;
        }

        case MAMemberDetailListTypeEMail: {
            MAMemberDetailCommonCell *detailCell = cell;
            detailCell.actionDelegate = self;
            detailCell.status = self.isEditing;
            detailCell.tag = MAMemberDetailListTypeEMail;
            NSString *mail = nil;
            if (self.isEditing) {
                mail = self.editingMail;
            } else {
                mail = self.member.eMail;
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"邮箱：",
                                       kMemberDetailCellContent:mail ? mail : @"",
                                       kMemberDetailCellKeyboardType:@(UIKeyboardTypeEmailAddress)};
            [detailCell reuseCellWithData:cellInfo];
            break;
        }

        case MAMemberDetailListTypeBirthday: {
            MAMemberDetailBirthdayCell *detailCell = cell;
            detailCell.actionDelegate = self;
            detailCell.status = self.isEditing;
            detailCell.tag = MAMemberDetailListTypeBirthday;
            if (self.isEditing) {
                [detailCell reuseCellWithData:self.editingBirthday];
            } else {
                [detailCell reuseCellWithData:self.member.birthday];
            }
            break;
        }

        default: {
            NSAssert(NO, @"Wrong row number in table view, infoOfRow!");
            break;
        }
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

#pragma mark - MACellActionDelegate

- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    switch (type) {
        case MAMemberDetailListTypeName: {
            self.editingName = data;
            break;
        }
        case MAMemberDetailListTypeGender: {
            self.editingGender = [data integerValue];
            break;
        }
        case MAMemberDetailListTypeTelephone: {
            self.editingPhone = data;
            break;
        }
        case MAMemberDetailListTypeEMail: {
            self.editingMail = data;
            break;
        }
        case MAMemberDetailListTypeBirthday: {
            self.editingBirthday = data;
            break;
        }
        default: {
            NSAssert(NO, @"Wrong row number in table view, infoOfRow!");
            break;
        }
    }

    return YES;
}

#pragma mark - property

- (UIBarButtonItem *)cancelBarItem
{
    if (_cancelBarItem) {
        return _cancelBarItem;
    }

    _cancelBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancelButtonTaped:)];
    return _cancelBarItem;
}

#pragma mark - action

- (void)didEditButtonTaped:(UIBarButtonItem *)sender
{
    [self refreshEditingData];
    [self setEditing:YES animated:YES];
}

- (void)didSaveButtonTaped:(UIBarButtonItem *)sender
{
    if (self.isCreateMode) {
        // create mode
        self.member = [FriendManager createFriendWithName:self.editingName
                                                   gender:self.editingGender
                                              phoneNumber:@([self.editingPhone longLongValue])
                                                    eMail:self.editingMail
                                                 birthday:self.editingBirthday];
        if (self.member) {
            [self setEditing:NO animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            // TODO:
        }
    } else {
        // not create mode
        BOOL updated = [FriendManager editAndSaveFriend:self.member
                                                   name:self.editingName
                                                 gender:self.editingGender
                                            phoneNumber:@([self.editingPhone longLongValue])
                                                  eMail:self.editingMail
                                               birthday:self.editingBirthday];
        if (updated) {
            [self setEditing:NO animated:YES];
        } else {
            // TODO:
        }
    }
}

- (void)didCancelButtonTaped:(UIBarButtonItem *)sender
{
    if (self.editing) {
        MAAlertView *alert = nil;
        if (self.isCreateMode) {
            alert = [MAAlertView alertWithTitle:@"确认放弃创建么？"
                                        message:nil
                                   buttonTitle1:@"放弃创建"
                                   buttonBlock1:^{
                                       [self clearEditingData];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }
                                   buttonTitle2:@"点错了~"
                                   buttonBlock2:nil];
        } else {
            alert = [MAAlertView alertWithTitle:@"确认放弃更改么？"
                                        message:nil
                                   buttonTitle1:@"放弃更改"
                                   buttonBlock1:^{
                                       [self clearEditingData];
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
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didSaveButtonTaped:)] animated:YES];

    } else {
        [self.accountButton setHidden:NO];
        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didEditButtonTaped:)] animated:YES];
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

@end