//
//  MBProgressHUD+MAAddition.h
//  MatesAccounting
//
//  Created by Lee on 14-2-23.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MAAddition)

+ (void)showTextHUDOnView:(UIView *)view
                     text:(NSString *)text
          completionBlock:(MBProgressHUDCompletionBlock)completionBlock
                 animated:(BOOL)animated;

+ (void)showWaitHUDOnView:(UIView *)view
                     text:(NSString *)text
          completionBlock:(MBProgressHUDCompletionBlock)completionBlock
                 animated:(BOOL)animated;

+ (void)hideWaitHUDOnView:(UIView *)view
                 animated:(BOOL)animated;

@end