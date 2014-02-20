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

@property (nonatomic, assign) BOOL hasEdited;

@end

@implementation MAGroupDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        self.hasEdited = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(groupHasModified:)
                                                     name:MAGroupManagerGroupHasModified
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.detailScrollView.contentSize = CGSizeMake(320, self.cancelButton.bottom + 88);
    [self refreshView];
}

- (void)refreshView
{
    if (self.isCreateMode) {
        [self.groupCreateTimeLabel setText:[[NSDate date] description]];
        [self.groupIDLabel setText:@"创建后生成"];
        [self.submitButton setTitle:@"创建" forState:UIControlStateNormal];
    } else {
        [self.groupCreateTimeLabel setText:[self.group.createDate description]];
        [self.groupIDLabel setText:[self.group.groupID stringValue]];
        [self.groupNameTextField setText:self.group.groupName];
        [self.submitButton setTitle:@"修改" forState:UIControlStateNormal];
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

    if (self.isCreateMode) {
        [GroupManager createGroup:newGroupName];
    } else {
        [GroupManager editAndSaveGroup:self.group name:newGroupName];
    }

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)cancelButtonTaped:(UIButton *)sender
{
    if (self.hasEdited) {
        [[MAAlertView alertWithTitle:@"要放弃已输入的内容么？"
                             message:nil
                        buttonTitle1:@"确认放弃"
                        buttonBlock1:nil
                        buttonTitle2:@"点错了~"
                        buttonBlock2:^{
                            [self dismissViewControllerAnimated:YES completion:^{
                            }];
                        }] show];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (IBAction)didGroupNameTextFieldBeginEdit:(UITextField *)sender
{
    // TODO: 判断textField是否被键盘遮住
    self.hasEdited = YES;
}

- (IBAction)didGroupNameTextFieldEndEdit:(UITextField *)sender
{
    // TODO: 判断textField是否被键盘遮住
}

- (IBAction)groupNameTextFieldDoneTaped:(UITextField *)sender
{
    [sender resignFirstResponder];
}

#pragma mark - notifications

- (void)groupHasModified:(NSNotification *)notification
{
    if (notification.object == self.group) {
        [self refreshView];
    }
}

@end