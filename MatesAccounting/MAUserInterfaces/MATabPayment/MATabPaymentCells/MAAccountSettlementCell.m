//
//  MAAccountSettlementCell.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-6.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAAccountSettlementCell.h"

@interface MAAccountSettlementCell ()

@end

@implementation MAAccountSettlementCell

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
  return 80.0f;
}

+ (NSString *)reuseIdentifier
{
  return [self className];
}

@end