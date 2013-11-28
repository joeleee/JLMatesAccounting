//
//  MAGroupListCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupListCell.h"

@interface MAGroupListCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCreateDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupAccountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupTotalFeeLabel;

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

@end