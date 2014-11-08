//
//  MAActionSheet.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MAActionSheetButtonBlock)(void);


@interface MAActionSheet : NSObject

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                         buttonTitle:(NSString *)buttonTitle
                         buttonBlock:(MAActionSheetButtonBlock)buttonBlock;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                        buttonTitle1:(NSString *)buttonTitle1
                        buttonBlock1:(MAActionSheetButtonBlock)buttonBlock1
                        buttonTitle2:(NSString *)buttonTitle2
                        buttonBlock2:(MAActionSheetButtonBlock)buttonBlock2;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                   otherButtonTitles:(NSArray *)otherButtonTitles
                   otherButtonBlocks:(NSArray *)otherButtonBlocks;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                  buttonTitle:(NSString *)buttonTitle
                  buttonBlock:(MAActionSheetButtonBlock)buttonBlock;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                 buttonTitle1:(NSString *)buttonTitle1
                 buttonBlock1:(MAActionSheetButtonBlock)buttonBlock1
                 buttonTitle2:(NSString *)buttonTitle2
                 buttonBlock2:(MAActionSheetButtonBlock)buttonBlock2;

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
            otherButtonTitles:(NSArray *)otherButtonTitles
            otherButtonBlocks:(NSArray *)otherButtonBlocks;

- (void)showFromToolbar:(UIToolbar *)view;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated NS_AVAILABLE_IOS(3_2);
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated NS_AVAILABLE_IOS(3_2);
- (void)showInView:(UIView *)view;

@end