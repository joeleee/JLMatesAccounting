//
//  MBProgressHUD+MAAddition.m
//  MatesAccounting
//
//  Created by Lee on 14-2-23.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MBProgressHUD+MAAddition.h"

@implementation MBProgressHUD (MAAddition)

+ (void)showTextHUDOnView:(UIView *)view
                     text:(NSString *)text
          completionBlock:(MBProgressHUDCompletionBlock)completionBlock
                 animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];

    if (hud) {
        if (MBProgressHUDModeText == hud.mode) {
            [hud hide:NO];
            hud = [self hudOnView:view
                             text:text
                             mode:MBProgressHUDModeText
                  completionBlock:completionBlock
                         animated:animated];
            [hud show:NO];
        } else {
            MBProgressHUDCompletionBlock block = [hud.completionBlock copy];
            hud.completionBlock = ^{
                EXECUTE_BLOCK_SAFELY(block);
                [self showTextHUDOnView:view
                                   text:text
                        completionBlock:completionBlock
                               animated:animated];
            };
        }
    } else {
        hud = [self hudOnView:view
                         text:text
                         mode:MBProgressHUDModeText
              completionBlock:completionBlock
                     animated:animated];
        [hud show:animated];
    }
}

+ (void)showWaitHUDOnView:(UIView *)view
                     text:(NSString *)text
          completionBlock:(MBProgressHUDCompletionBlock)completionBlock
                 animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];

    if (hud && MBProgressHUDModeIndeterminate == hud.mode) {
        EXECUTE_BLOCK_SAFELY(hud.completionBlock);
        hud.completionBlock = completionBlock;
        hud.detailsLabelText = text;
    } else {
        [hud hide:NO];
        hud = [self hudOnView:view
                         text:text
                         mode:MBProgressHUDModeIndeterminate
              completionBlock:completionBlock
                     animated:animated];
        [hud show:animated];
    }
}

+ (void)hideWaitHUDOnView:(UIView *)view
                 animated:(BOOL)animated
{
    NSArray *allHUD = [self allHUDsForView:view];
    for (MBProgressHUD *hud in allHUD) {
        if (MBProgressHUDModeIndeterminate == hud.mode) {
            [hud hide:animated];
        }
    }
}

#pragma mark - private

+ (MBProgressHUD *)hudOnView:(UIView *)view
                        text:(NSString *)text
                        mode:(MBProgressHUDMode)mode
             completionBlock:(MBProgressHUDCompletionBlock)completionBlock
                    animated:(BOOL)animated
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:hud];

    hud.removeFromSuperViewOnHide = YES;
    hud.mode = mode;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.completionBlock = completionBlock;

    if (MBProgressHUDModeText == mode || MBProgressHUDModeCustomView == mode) {
        hud.dimBackground = NO;
        hud.labelText = text;
        hud.detailsLabelText = @"";
        [hud hide:animated afterDelay:1.3f];
    } else {
        hud.dimBackground = YES;
        hud.labelText = @"";
        hud.detailsLabelText = text;
    }

    return hud;
}

@end