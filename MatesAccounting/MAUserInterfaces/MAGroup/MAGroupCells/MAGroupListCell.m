//
//  MAGroupListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupListCell.h"

#import "MGroup.h"

@interface MAGroupListCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCreateDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupAccountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTotalFeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupDetailButton;

@property (nonatomic, strong) MGroup *group;

@end

@implementation MAGroupListCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)reuseCellWithData:(id)data
{
}

+ (CGFloat)cellHeight:(id)data
{
    return 0.0f;
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

- (IBAction)didGroupDetailButtonTaped:(UIButton *)sender
{
    [self.actionDelegate actionWithData:self.group
                                   cell:self
                                   type:0];
}

@end