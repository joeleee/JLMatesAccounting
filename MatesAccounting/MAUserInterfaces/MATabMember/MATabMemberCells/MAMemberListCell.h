//
//  MAMemberListCell.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAMemberListCell : UITableViewCell <MACellReuseProtocol>

@property (nonatomic, weak) id<MACellActionDelegate> actionDelegate;

@end