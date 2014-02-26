//
//  MAMemberDetailViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFriend;

@interface MAMemberDetailViewController : UIViewController

@property (nonatomic, strong) MFriend *mFriend;
@property (nonatomic, assign) BOOL isCreateMode;

@end