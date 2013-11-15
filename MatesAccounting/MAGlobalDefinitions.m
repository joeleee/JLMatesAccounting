//
//  MAGlobalDefinitions.m
//  MatesAccounting
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGlobalDefinitions.h"

#ifndef MAGLOBALDEFINITIONS_H
  #define MAGLOBALDEFINITIONS_H

  #define EXECUTE_BLOCK_SAFELY(block, ...) { \
        if (block) {                         \
            block(__VA_ARGS__);              \
        }                                    \
}
#endif /* ifndef MAGLOBALDEFINITIONS_H */

#pragma mark - definition blocks