//
//  MAGroupDetailViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-30.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupDetailViewController.h"

#import "MGroup.h"
#import "MAGroupManager.h"

@interface MAGroupDetailViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *groupCreateTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIDTitle;
@property (weak, nonatomic) IBOutlet UILabel *groupIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameTitle;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (nonatomic, strong) UIBarButtonItem *updateBarItem;
@property (nonatomic, strong) UIBarButtonItem *createBarItem;
@property (nonatomic, strong) UIBarButtonItem *cancelBarItem;

@property (nonatomic, strong) MGroup *group;
@property (nonatomic, assign) BOOL isModified;
@property (nonatomic, copy) NSString *editingGroupName;

@end

@implementation MAGroupDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.isModified = YES;
        self.editingGroupName = nil;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];
    [self.groupNameTextField addTarget:self action:@selector(groupNameTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    self.groupCreateTimeTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupCreateTimeLabel.textColor = MA_COLOR_GROUP_GROUP_NAME;
    self.groupIDTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupIDLabel.textColor = MA_COLOR_GROUP_GROUP_NAME;
    self.groupNameTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    [self.sendEmailButton setTitleColor:MA_COLOR_TABMEMBER_PAYER_NAME forState:UIControlStateNormal];
    [self.sendEmailButton setBackgroundColor:MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY];

    self.sendEmailButton.layer.cornerRadius = 7;
    self.sendEmailButton.layer.shadowColor = [MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY CGColor];
    self.sendEmailButton.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.sendEmailButton.layer.shadowOpacity = 0.2f;
    self.sendEmailButton.layer.shadowRadius = 1.5f;

    self.groupNameTextField.layer.cornerRadius = 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshView];
    if (!self.group) {
        [self.groupNameTextField becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)refreshView
{
    if (self.group) {
        [self setTitle:@"Group Detail"];
        [self.groupCreateTimeLabel setText:[self.group.createDate dateToString:@"yyyy-MM-dd HH:mm"]];
        [self.groupIDLabel setText:[self.group.groupID stringValue]];
        [self.groupNameTextField setText:self.editingGroupName];
        self.sendEmailButton.hidden = NO;
        if (self.isModified) {
            [self.navigationItem setRightBarButtonItem:self.updateBarItem animated:YES];
            [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
        }
    } else {
        [self setTitle:@"New Group"];
        [self.groupCreateTimeLabel setText:[[NSDate date] dateToString:@"yyyy-MM-dd HH:mm"]];
        [self.groupIDLabel setText:@"Later you can get"];
        self.sendEmailButton.hidden = YES;
        [self.navigationItem setRightBarButtonItem:self.createBarItem animated:YES];
        [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
    }
}


#pragma mark - property

- (UIBarButtonItem *)updateBarItem
{
    if (_updateBarItem) {
        return _updateBarItem;
    }

    _updateBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(didDoneBarButtonTapped:)];
    return _updateBarItem;
}

- (UIBarButtonItem *)createBarItem
{
    if (_createBarItem) {
        return _createBarItem;
    }

    _createBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(didDoneBarButtonTapped:)];
    return _createBarItem;
}

- (UIBarButtonItem *)cancelBarItem
{
    if (_cancelBarItem) {
        return _cancelBarItem;
    }

    _cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(didCancelBarButtonTapped:)];
    return _cancelBarItem;
}


#pragma mark - actions

- (IBAction)didSendEmailButtonTapped:(id)sender
{
}

- (void)didDoneBarButtonTapped:(id)sender
{
    if (0 >= self.editingGroupName.length) {
        [[MAAlertView alertWithTitle:@"Group name could not be NULL"
                             message:nil
                         buttonTitle:@"Return"
                         buttonBlock:^{
                             [self.groupNameTextField becomeFirstResponder];
                         }] show];
        return;
    }

    if (self.group) {
        [GroupManager editAndSaveGroup:self.group name:self.editingGroupName];
    } else {
        [GroupManager createGroup:self.editingGroupName];
    }

    [self disappear:YES];
}

- (void)didCancelBarButtonTapped:(id)sender
{
    [self disappear:YES];
}

- (void)groupNameTextFieldEditingChanged:(UITextField *)textField
{
    self.editingGroupName = textField.text;

    if (self.group) {
        if ([self.editingGroupName isEqualToString:self.group.groupName]) {
            self.isModified = NO;
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        } else {
            self.isModified = YES;
            [self.navigationItem setRightBarButtonItem:self.updateBarItem animated:YES];
            [self.navigationItem setLeftBarButtonItem:self.cancelBarItem animated:YES];
        }
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // TODO: 判断textField是否被键盘遮住
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // TODO: 判断textField是否被键盘遮住
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        MA_HIDE_KEYBOARD;
        return YES;
    }

    return NO;
}


#pragma mark - Public Method

- (void)setGroup:(MGroup *)group
{
    _group = group;
    self.isModified = NO;
    self.editingGroupName = _group.groupName;
    [self refreshView];
}

@end