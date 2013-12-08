//
//  MAMemberDetailViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-12-8.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMember;

@interface MAMemberDetailViewController : UIViewController

@property (nonatomic, strong) MMember *member;
@property (nonatomic, assign) BOOL isCreateMode;

@end