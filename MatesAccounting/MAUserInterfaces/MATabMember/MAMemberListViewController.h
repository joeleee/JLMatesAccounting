//
//  MAMemberListViewController.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGroup;
@protocol MAMemberListViewControllerDelegate;

@interface MAMemberListViewController : UIViewController

@property (nonatomic, strong) MGroup *group;
@property (nonatomic, strong) NSArray *selectedMembers;
@property (nonatomic, weak) id <MAMemberListViewControllerDelegate> delegate;

@end


@protocol MAMemberListViewControllerDelegate <NSObject>

@optional
- (void)memberListController:(MAMemberListViewController *)selder didFinishedSelectMember:(NSArray *)selectedMembers;
- (void)memberListControllerDidCancelSelectMember:(MAMemberListViewController *)selder;

@end