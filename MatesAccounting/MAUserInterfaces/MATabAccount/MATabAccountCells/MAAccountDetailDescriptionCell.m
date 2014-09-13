//
//  MAAccountDetailDescriptionCell.m
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAccountDetailDescriptionCell.h"

@interface MAAccountDetailDescriptionCell () <UITextViewDelegate, MAManualLayoutAfterLayoutSubviewsProtocol>

@property (weak, nonatomic) IBOutlet UITextView *accountDescriptionTextView;

@end

@implementation MAAccountDetailDescriptionCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self needManualLayoutAfterLayoutSubviews];
    }

    return self;
}

- (void)reuseCellWithData:(NSString *)data
{
    [self.accountDescriptionTextView setText:data];
    if (self.status) {
        self.accountDescriptionTextView.backgroundColor = MA_COLOR_TABACCOUNT_DETAIL_EDITVIEW;
        self.accountDescriptionTextView.textColor = [UIColor blackColor];
    } else {
        self.accountDescriptionTextView.backgroundColor = [UIColor clearColor];
        self.accountDescriptionTextView.textColor = MA_COLOR_TABACCOUNT_DETAIL_DESCRIPTION;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return self.status;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.actionDelegate actionWithData:textView cell:self type:0];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.actionDelegate actionWithData:textView cell:self type:1];
}

+ (CGFloat)cellHeight:(id)data
{
    return 110.0f;
}

#pragma mark MAManualLayoutAfterLayoutSubviewsProtocol
- (void)manualLayoutAfterLayoutSubviews
{
    self.accountDescriptionTextView.scrollsToTop = NO;
    self.accountDescriptionTextView.layer.cornerRadius = 5.0;
}

@end