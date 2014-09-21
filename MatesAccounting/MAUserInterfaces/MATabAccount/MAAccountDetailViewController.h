//
//  MAAccountDetailViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-12-1.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGroup, MAccount;

@interface MAAccountDetailViewController : UIViewController

- (void)setAccount:(MAccount *)account;

- (void)setGroup:(MGroup *)group;

@end