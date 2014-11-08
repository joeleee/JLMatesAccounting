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
@property (nonatomic, copy) NSString *editingName;
@property (nonatomic, assign) MAGenderEnum editingGender;
@property (nonatomic, copy) NSString *editingPhone;
@property (nonatomic, copy) NSString *editingMail;
@property (nonatomic, strong) NSDate *editingBirthday;

@end