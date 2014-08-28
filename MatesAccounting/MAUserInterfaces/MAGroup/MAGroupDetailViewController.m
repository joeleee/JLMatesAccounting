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
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) MGroup *group;

@end

@implementation MAGroupDetailViewController

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

    self.groupCreateTimeTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupCreateTimeLabel.textColor = MA_COLOR_GROUP_GROUP_NAME;
    self.groupIDTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;
    self.groupIDLabel.textColor = MA_COLOR_GROUP_GROUP_NAME;
    self.groupNameTitle.textColor = MA_COLOR_GROUP_GROUP_TITLE;

    self.detailScrollView.contentSize = CGSizeMake(320, self.cancelButton.bottom + 88);

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

- (void)refreshView
{
    if (self.group) {
        [self.groupCreateTimeLabel setText:[self.group.createDate dateToString:@"yyyy-MM-dd HH:mm"]];
        [self.groupIDLabel setText:[self.group.groupID stringValue]];
        [self.groupNameTextField setText:self.group.groupName];
        [self.submitButton setTitle:@"Update" forState:UIControlStateNormal];
    } else {
        [self.groupCreateTimeLabel setText:[[NSDate date] dateToString:@"yyyy-MM-dd HH:mm"]];
        [self.groupIDLabel setText:@"Later you can get"];
        [self.submitButton setTitle:@"Create" forState:UIControlStateNormal];
    }
    [self.cancelButton setTitle:@"Back" forState:UIControlStateNormal];
}

#pragma mark - actions
- (IBAction)submitButtonTaped:(UIButton *)sender
{
    NSString *newGroupName = [self.groupNameTextField text];
    if (0 >= newGroupName.length) {
        [[MAAlertView alertWithTitle:@"Group name could not be NULL"
                             message:nil
                         buttonTitle:@"Return"
                         buttonBlock:^{
                             [self.groupNameTextField becomeFirstResponder];
                         }] show];
        return;
    }

    if (self.group) {
        [GroupManager editAndSaveGroup:self.group name:newGroupName];
    } else {
        [GroupManager createGroup:newGroupName];
    }

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)cancelButtonTaped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (IBAction)didGroupNameTextFieldBeginEdit:(UITextField *)sender
{
    // TODO: 判断textField是否被键盘遮住
}

- (IBAction)didGroupNameTextFieldEndEdit:(UITextField *)sender
{
    // TODO: 判断textField是否被键盘遮住
}

- (IBAction)groupNameTextFieldDoneTaped:(UITextField *)sender
{
    MA_HIDE_KEYBOARD;
}

#pragma mark - Public Method

- (void)setGroup:(MGroup *)group
{
    _group = group;
    [self refreshView];
}

@end