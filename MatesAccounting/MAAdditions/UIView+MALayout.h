//
//  UIView+MALayout.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-27.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAManualLayoutAfterLayoutSubviewsProtocol <NSObject>

@required
- (void)manualLayoutAfterLayoutSubviews;

@end

@interface UIView (MALayout)

- (void)needManualLayoutAfterLayoutSubviews;

@end