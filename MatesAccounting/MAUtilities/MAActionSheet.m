//
//  MAActionSheet.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAActionSheet.h"


NSUInteger const maxActionSheetQueueCount = 18;

@interface MAActionSheet () <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) NSMutableArray *buttonBlocks;

@end


@implementation MAActionSheet

static NSMutableOrderedSet *currentActionSheetQueue;



+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                         buttonTitle:(NSString *)buttonTitle
                         buttonBlock:(MAActionSheetButtonBlock)buttonBlock
{
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                     cancelButtonBlock:cancelButtonBlock
                destructiveButtonTitle:destructiveButtonTitle
                destructiveButtonBlock:destructiveButtonBlock
                           buttonTitle:buttonTitle
                           buttonBlock:buttonBlock];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                        buttonTitle1:(NSString *)buttonTitle1
                        buttonBlock1:(MAActionSheetButtonBlock)buttonBlock1
                        buttonTitle2:(NSString *)buttonTitle2
                        buttonBlock2:(MAActionSheetButtonBlock)buttonBlock2
{
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                     cancelButtonBlock:cancelButtonBlock
                destructiveButtonTitle:destructiveButtonTitle
                destructiveButtonBlock:destructiveButtonBlock
                          buttonTitle1:buttonTitle1
                          buttonBlock1:buttonBlock1
                          buttonTitle2:buttonBlock2
                          buttonBlock2:buttonBlock2];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
              destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                   otherButtonTitles:(NSArray *)otherButtonTitles
                   otherButtonBlocks:(NSArray *)otherButtonBlocks
{
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                     cancelButtonBlock:cancelButtonBlock
                destructiveButtonTitle:destructiveButtonTitle
                destructiveButtonBlock:destructiveButtonBlock
                     otherButtonTitles:otherButtonTitles
                     otherButtonBlocks:otherButtonBlocks];
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                  buttonTitle:(NSString *)buttonTitle
                  buttonBlock:(MAActionSheetButtonBlock)buttonBlock
{
    self.buttonBlocks = [NSMutableArray array];
    if (destructiveButtonTitle) {
        [self.buttonBlocks addObject:destructiveButtonBlock ? destructiveButtonBlock : ^{}];
    }
    [self.buttonBlocks addObject:buttonBlock ? buttonBlock : ^{}];
    if (cancelButtonTitle) {
        [self.buttonBlocks addObject:cancelButtonBlock ? cancelButtonBlock : ^{}];
    }

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:buttonTitle, nil];

    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
                 buttonTitle1:(NSString *)buttonTitle1
                 buttonBlock1:(MAActionSheetButtonBlock)buttonBlock1
                 buttonTitle2:(NSString *)buttonTitle2
                 buttonBlock2:(MAActionSheetButtonBlock)buttonBlock2
{
    self.buttonBlocks = [NSMutableArray array];
    if (destructiveButtonTitle) {
        [self.buttonBlocks addObject:destructiveButtonBlock ? destructiveButtonBlock : ^{}];
    }
    [self.buttonBlocks addObject:buttonBlock1 ? buttonBlock1 : ^{}];
    [self.buttonBlocks addObject:buttonBlock2 ? buttonBlock2 : ^{}];
    if (cancelButtonTitle) {
        [self.buttonBlocks addObject:cancelButtonBlock ? cancelButtonBlock : ^{}];
    }

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:buttonTitle1, buttonTitle2, nil];

    return self;
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelButtonBlock:(MAActionSheetButtonBlock)cancelButtonBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveButtonBlock:(MAActionSheetButtonBlock)destructiveButtonBlock
            otherButtonTitles:(NSArray *)otherButtonTitles
            otherButtonBlocks:(NSArray *)otherButtonBlocks
{
    if (otherButtonTitles.count != otherButtonTitles.count) {
        MA_ASSERT_FAILED(@"otherButtonTitles.count != otherButtonTitles.count");
        return nil;
    }

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    self.buttonBlocks = [NSMutableArray array];
    if (destructiveButtonTitle) {
        self.actionSheet.destructiveButtonIndex = [self.actionSheet addButtonWithTitle:destructiveButtonTitle];
        [self.buttonBlocks addObject:destructiveButtonBlock ? destructiveButtonBlock : ^{}];
    }
    for (NSString *buttonTitle in otherButtonTitles) {
        [self.actionSheet addButtonWithTitle:buttonTitle];
    }
    [self.buttonBlocks addObjectsFromArray:otherButtonBlocks];
    if (cancelButtonTitle) {
        self.actionSheet.cancelButtonIndex = [self.actionSheet addButtonWithTitle:cancelButtonTitle];
        [self.buttonBlocks addObject:cancelButtonBlock ? cancelButtonBlock : ^{}];
    }

    return self;
}

- (void)showFromToolbar:(UIToolbar *)view
{
    [MAActionSheet addActionSheetToQueue:self];
    [self.actionSheet showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
    [MAActionSheet addActionSheetToQueue:self];
    [self.actionSheet showFromTabBar:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    [MAActionSheet addActionSheetToQueue:self];
    [self.actionSheet showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
    [MAActionSheet addActionSheetToQueue:self];
    [self.actionSheet showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
    [MAActionSheet addActionSheetToQueue:self];
    [self.actionSheet showInView:view];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:animated];
}


#pragma mark - MAAlertView的生命周期控制，防止自己被释放，造成野指针

+ (BOOL)addActionSheetToQueue:(MAActionSheet *)actionSheet
{
    if (!actionSheet) {
        return NO;
    }

    if (!currentActionSheetQueue) {
        currentActionSheetQueue = [NSMutableOrderedSet orderedSetWithCapacity:maxActionSheetQueueCount];
    }

    if (maxActionSheetQueueCount <= currentActionSheetQueue.count) {
        [currentActionSheetQueue removeObjectAtIndex:0];
        [currentActionSheetQueue addObject:actionSheet];
        return NO;
    }

    [currentActionSheetQueue addObject:actionSheet];
    return YES;
}

+ (BOOL)removeActionSheetFromQueue:(MAActionSheet *)actionSheet
{
    if ([currentActionSheetQueue containsObject:actionSheet]) {
        [currentActionSheetQueue removeObject:actionSheet];
        return YES;
    }

    return NO;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MAAlertViewButtonBlock block = nil;
    if (buttonIndex < self.buttonBlocks.count) {
        block = self.buttonBlocks[buttonIndex];
    }
    if (block) {
        block();
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [MAActionSheet removeActionSheetFromQueue:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [MAActionSheet removeActionSheetFromQueue:self];
}

@end