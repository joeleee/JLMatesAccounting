//
//  MAAlertView.h
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MAAlertViewButtonBlock)(void);

@interface MAAlertView : NSObject <UIAlertViewDelegate>

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                    buttonTitle:(NSString *)buttonTitle
                    buttonBlock:(MAAlertViewButtonBlock)buttonBlock;

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                   buttonTitle1:(NSString *)buttonTitle1
                   buttonBlock1:(MAAlertViewButtonBlock)buttonBlock1
                   buttonTitle2:(NSString *)buttonTitle2
                   buttonBlock2:(MAAlertViewButtonBlock)buttonBlock2;

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                   buttonBlocks:(NSArray *)buttonBlocks
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        buttonTitle:(NSString *)buttonTitle
        buttonBlock:(MAAlertViewButtonBlock)buttonBlock;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       buttonTitle1:(NSString *)buttonTitle1
       buttonBlock1:(MAAlertViewButtonBlock)buttonBlock1
       buttonTitle2:(NSString *)buttonTitle2
       buttonBlock2:(MAAlertViewButtonBlock)buttonBlock2;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       buttonBlocks:(NSArray *)buttonBlocks
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)show;

@end