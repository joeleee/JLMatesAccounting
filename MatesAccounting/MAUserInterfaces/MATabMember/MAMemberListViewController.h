//
//  MAMemberListViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAccount;

@interface MAMemberListViewController : UIViewController

@property (nonatomic, strong) MAccount *account;
@property (nonatomic, assign) BOOL isPayers;

@end