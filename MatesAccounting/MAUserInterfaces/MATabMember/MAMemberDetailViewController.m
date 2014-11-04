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
#import "UIViewController+MAAddition.h"
#import "MAMemberAccountListViewController.h"

NSString * const kSegueMemberDetailToAccountList = @"kSegueMemberDetailToAccountList";

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

@property (nonatomic, strong) MFriend *mFriend;
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
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];

    if (self.mFriend) {
        [self setEditing:NO animated:NO];
        self.title = self.mFriend.name;
    } else {
        [self setEditing:YES animated:NO];
        self.title = @"Create friend";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueMemberDetailToAccountList]) {
        MAMemberAccountListViewController *accountList = segue.destinationViewController;
        [accountList setMember:self.mFriend];
    } else {
        MA_ASSERT(NO, @"Unknow segue - MAFriendListViewController");
    }
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
            MA_ASSERT(NO, @"Wrong row number in table view, infoOfRow!");
            break;
    }

    return @{kMemberDetailRowType:@(rowType),
             kMemberDetailCellHeight:@(rowHeight),
             kMemberDetailCellIdentifier:cellIdentifier};
}

- (void)clearEditingData
{
    self.editingName = nil;
    self.editingGender = MAGenderMale;
    self.editingPhone = nil;
    self.editingMail = nil;
    self.editingBirthday = nil;
}

- (void)refreshEditingData
{
    self.editingName = self.mFriend.name ? self.mFriend.name : @"";
    self.editingGender = [self.mFriend.sex unsignedIntValue];
    self.editingPhone = [self.mFriend.telephoneNumber stringValue];
    self.editingMail = self.mFriend.eMail ? self.mFriend.eMail : @"";
    self.editingBirthday = self.mFriend.birthday;
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowInfo = [self tableView:tableView infoOfRow:indexPath.row];

    NSString *cellIdentifier = [rowInfo objectForKey:kMemberDetailCellIdentifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    MAMemberDetailListType rowType = [[rowInfo objectForKey:kMemberDetailRowType] unsignedIntValue];
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
                name = self.mFriend.name;
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"Name",
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
                [detailCell reuseCellWithData:self.mFriend.sex];
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
                phoneString = [self.mFriend.telephoneNumber stringValue];
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"Phone",
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
                mail = self.mFriend.eMail;
            }
            NSDictionary *cellInfo = @{kMemberDetailCellTitle:@"E-mail",
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
                [detailCell reuseCellWithData:self.mFriend.birthday];
            }
            break;
        }

        default: {
            MA_ASSERT(NO, @"Wrong row number in table view, infoOfRow!");
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    MA_HIDE_KEYBOARD;
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
            self.editingGender = [data unsignedIntValue];
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
            MA_ASSERT(NO, @"Wrong row number in table view, infoOfRow!");
            break;
        }
    }

    return YES;
}

#pragma mark - action

- (void)didEditButtonTaped:(UIBarButtonItem *)sender
{
    [self refreshEditingData];
    [self setEditing:YES animated:YES];
}

- (void)didSaveButtonTaped:(UIBarButtonItem *)sender
{
    MA_HIDE_KEYBOARD;
    if (0 >= [self.editingName stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
        [[MAAlertView alertWithTitle:@"Name can not be NULL" message:nil buttonTitle:@"OK" buttonBlock:^{}] show];
        return;
    }

    if (self.mFriend) {
        // not create mode
        BOOL updated = [FriendManager editAndSaveFriend:self.mFriend
                                                   name:self.editingName
                                                 gender:self.editingGender
                                            phoneNumber:@([self.editingPhone longLongValue])
                                                  eMail:self.editingMail
                                               birthday:self.editingBirthday];
        if (updated) {
            [self setEditing:NO animated:YES];
        } else {
            [MBProgressHUD showTextHUDOnView:[UIApplication sharedApplication].delegate.window
                                        text:@"Update failed"
                             completionBlock:nil
                                    animated:YES];
        }
    } else {
        // create mode
        self.mFriend = [FriendManager createFriendWithName:self.editingName
                                                    gender:self.editingGender
                                               phoneNumber:@([self.editingPhone longLongValue])
                                                     eMail:self.editingMail
                                                  birthday:self.editingBirthday];
        if (self.mFriend) {
            [self setEditing:NO animated:YES];
            [self disappear:YES];
        } else {
            [MBProgressHUD showTextHUDOnView:[UIApplication sharedApplication].delegate.window
                                        text:@"Create failed"
                             completionBlock:nil
                                    animated:YES];
        }
    }
}

- (void)didCancelButtonTaped:(UIBarButtonItem *)sender
{
    if (self.editing) {
        MAAlertView *alert = nil;
        if (self.mFriend) {
            alert = [MAAlertView alertWithTitle:@"You will lost the modification"
                                        message:nil
                                   buttonTitle1:@"NO"
                                   buttonBlock1:nil
                                   buttonTitle2:@"YES"
                                   buttonBlock2:^{
                                       [self clearEditingData];
                                       [self setEditing:NO animated:YES];
                                   }];
        } else {
            [self clearEditingData];
            [self disappear:YES];
        }
        [alert show];
    } else {
        MA_ASSERT(NO, @"Wrong state, (didCancelButtonTaped:)");
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

- (IBAction)didAccountButtonTapped:(id)sender
{
    if (!self.mFriend) {
        MA_ASSERT(NO, @"self.mFriend is nil!");
        return;
    }

    [self performSegueWithIdentifier:kSegueMemberDetailToAccountList sender:sender];
}

#pragma mark - Public Method

- (void)setFriend:(MFriend *)mFriend
{
    self.mFriend = mFriend;
}

@end