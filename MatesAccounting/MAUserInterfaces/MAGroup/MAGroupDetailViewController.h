//
//  MAGroupDetailViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-11-30.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGroup;

@interface MAGroupDetailViewController : UIViewController

@property (nonatomic, strong) MGroup *group;
@property (nonatomic, assign) BOOL isCreateMode;

@end