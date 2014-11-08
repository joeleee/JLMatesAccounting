//
//  MAAddressBookManager.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFriend;

typedef void (^ReadContactCompletion)(NSString *name, NSDictionary *phoneNumbers, NSDictionary *emails, NSDate *birthday, NSError *error);


@interface MAAddressBookManager : NSObject

+ (MAAddressBookManager *)sharedManager;

- (BOOL)selectContactWithController:(UIViewController *)controller onCompletion:(ReadContactCompletion)completion;

@end