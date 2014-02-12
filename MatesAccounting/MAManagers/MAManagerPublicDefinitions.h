//
//  MAManagerPublicDefinitions.h
//  MatesAccounting
//
//  Created by Lee on 13-12-21.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

// 按需扩展
typedef enum {
    MACallBackSucceed = 0,
    MACallBackCommonFailed = 1
} MACommonCallBackBlockResultType;

typedef void (^ MACommonCallBackBlock) (MACommonCallBackBlockResultType resultType, id result, NSString *message, NSDictionary *extend);

@interface MAManagerPublicDefinitions : NSObject

@end