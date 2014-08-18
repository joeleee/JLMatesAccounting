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
@property (weak, nonatomic) IBOutlet UILabel *groupCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIDLabel;
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

    self.detailScrollView.contentSize = CGSizeMake(320, self.cancelButton.bottom + 88);
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
        [self.groupCreateTimeLabel setText:[self.group.createDate description]];
        [self.groupIDLabel setText:[self.group.groupID stringValue]];
        [self.groupNameTextField setText:self.group.groupName];
        [self.submitButton setTitle:@"修改" forState:UIControlStateNormal];
    } else {
        [self.groupCreateTimeLabel setText:[[NSDate date] description]];
        [self.groupIDLabel setText:@"创建后生成"];
        [self.submitButton setTitle:@"创建" forState:UIControlStateNormal];
    }
}

#pragma mark - actions
- (IBAction)submitButtonTaped:(UIButton *)sender
{
    NSString *newGroupName = [self.groupNameTextField text];
    if (0 >= newGroupName.length) {
        [[MAAlertView alertWithTitle:@"账目组名称不能为空"
                             message:nil
                         buttonTitle:@"重新填写"
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