//
//  MATabAccountGroupInfoCell.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountGroupInfoCell.h"

@interface MATabAccountGroupInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *miniBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@end

@implementation MATabAccountGroupInfoCell

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