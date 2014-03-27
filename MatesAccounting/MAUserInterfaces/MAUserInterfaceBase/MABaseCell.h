//
//  MABaseCell.h
//  MatesAccounting
//
//  Created by Lee on 13-12-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MACellProtocols.h"

@interface MABaseCell : UITableViewCell <MACellReuseProtocol>

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, weak) id <MACellActionDelegate> actionDelegate;

@end