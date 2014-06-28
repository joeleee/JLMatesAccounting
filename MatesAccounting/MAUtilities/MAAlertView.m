//
//  MAAlertView.m
//  MatesAccounting
//
//  Created by Lee on 13-12-7.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAlertView.h"

NSUInteger const maxAlertQueueCount = 18;

@interface MAAlertView ()

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *buttonBlocks;

@end

@implementation MAAlertView

static NSMutableOrderedSet *currentAlertQueue;

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                    buttonTitle:(NSString *)buttonTitle
                    buttonBlock:(MAAlertViewButtonBlock)buttonBlock
{
    MAAlertView *alertView = [[MAAlertView alloc] initWithTitle:title message:message buttonTitle:buttonTitle buttonBlock:buttonBlock];

    return alertView;
}

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                   buttonTitle1:(NSString *)buttonTitle1
                   buttonBlock1:(MAAlertViewButtonBlock)buttonBlock1
                   buttonTitle2:(NSString *)buttonTitle2
                   buttonBlock2:(MAAlertViewButtonBlock)buttonBlock2
{
    MAAlertView *alertView = [[MAAlertView alloc] initWithTitle:title message:message buttonTitle1:buttonTitle1 buttonBlock1:buttonBlock1 buttonTitle2:buttonTitle2 buttonBlock2:buttonBlock2];

    return alertView;
}

+ (MAAlertView *)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                   buttonBlocks:(NSArray *)buttonBlocks
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    MAAlertView *alertView = [[MAAlertView alloc] initWithTitle:title message:message buttonBlocks:buttonBlocks cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];

    return alertView;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        buttonTitle:(NSString *)buttonTitle
        buttonBlock:(MAAlertViewButtonBlock)buttonBlock
{
    self.buttonBlocks = [NSMutableArray array];
    if (buttonBlock) {
        [self.buttonBlocks addObject:[buttonBlock copy]];
    } else {
        MAAlertViewButtonBlock block = ^{};
        [self.buttonBlocks addObject:[block copy]];
    }

    self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:self
                                      cancelButtonTitle:buttonTitle
                                      otherButtonTitles:nil];

    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       buttonTitle1:(NSString *)buttonTitle1
       buttonBlock1:(MAAlertViewButtonBlock)buttonBlock1
       buttonTitle2:(NSString *)buttonTitle2
       buttonBlock2:(MAAlertViewButtonBlock)buttonBlock2
{
    self.buttonBlocks = [NSMutableArray array];
    if (buttonBlock1) {
        [self.buttonBlocks addObject:[buttonBlock1 copy]];
    } else {
        MAAlertViewButtonBlock block = ^{};
        [self.buttonBlocks addObject:[block copy]];
    }
    if (buttonBlock2) {
        [self.buttonBlocks addObject:[buttonBlock2 copy]];
    } else {
        MAAlertViewButtonBlock block = ^{};
        [self.buttonBlocks addObject:[block copy]];
    }

    self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:self
                                      cancelButtonTitle:buttonTitle1
                                      otherButtonTitles:buttonTitle2, nil];

    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       buttonBlocks:(NSArray *)buttonBlocks
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self.buttonBlocks = [NSMutableArray array];
    for (MAAlertViewButtonBlock block in buttonBlocks) {
        [self.buttonBlocks addObject:[block copy]];
    }

    self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:self
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:otherButtonTitles, nil];

    return self;
}

- (void)show
{
    [MAAlertView addAlertViewToQueue:self];
    [self.alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MAAlertViewButtonBlock block = nil;
    if (buttonIndex < self.buttonBlocks.count) {
        block = self.buttonBlocks[buttonIndex];
    }
    if (block) {
        block();
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [MAAlertView removeAlertViewFromQueue:self];
}

#pragma mark - MAAlertView的生命周期控制，防止自己被释放，造成野指针
+ (BOOL)addAlertViewToQueue:(MAAlertView *)alertView
{
    if (!alertView) {
        return NO;
    }

    if (!currentAlertQueue) {
        currentAlertQueue = [NSMutableOrderedSet orderedSetWithCapacity:maxAlertQueueCount];
    }

    if (maxAlertQueueCount <= currentAlertQueue.count) {
        [currentAlertQueue removeObjectAtIndex:0];
        [currentAlertQueue addObject:alertView];
        return NO;
    }

    [currentAlertQueue addObject:alertView];
    return YES;
}

+ (BOOL)removeAlertViewFromQueue:(MAAlertView *)alertView
{
    if ([currentAlertQueue containsObject:alertView]) {
        [currentAlertQueue removeObject:alertView];
        return YES;
    }

    return NO;
}

@end