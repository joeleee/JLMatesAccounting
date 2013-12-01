//
//  MAGroupDetailViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-30.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupDetailViewController.h"

@interface MAGroupDetailViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *goupCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

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

#pragma mark - private

#pragma mark actions
- (IBAction)submitButtonTaped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)cancelButtonTaped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
    [sender resignFirstResponder];
}

@end