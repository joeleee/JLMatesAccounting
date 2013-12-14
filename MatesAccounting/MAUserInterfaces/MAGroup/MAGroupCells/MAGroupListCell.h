//
//  MAGroupListCell.h
//  MatesAccounting
//
//  Created by Lee on 13-11-29.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAGroupListCell : UITableViewCell <MACellReuseProtocol>

@property (nonatomic, weak) id<MACellActionDelegate> actionDelegate;

@end