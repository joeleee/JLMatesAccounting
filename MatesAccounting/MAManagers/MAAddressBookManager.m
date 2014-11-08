//
//  MAAddressBookManager.m
//  MatesAccounting
//
//  Created by Joe Lee on 2014-11-8.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "MAAddressBookManager.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MFriend.h"


@interface MAAddressBookManager () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *currentSelectingController;
@property (nonatomic, strong) ReadContactCompletion readContactCompletion;

@end


@implementation MAAddressBookManager

+ (MAAddressBookManager *)sharedManager
{
    static MAAddressBookManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MAAddressBookManager alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        self.currentSelectingController = nil;
        self.readContactCompletion = nil;
    }

    return self;
}

- (BOOL)selectContactWithController:(UIViewController *)controller onCompletion:(ReadContactCompletion)completion
{
    MA_ASSERT(controller, @"Controller should not be nil.");

    if (self.currentSelectingController) {
        MA_ASSERT_FAILED(@"You are already in contact selecting page.");
        MA_INVOKE_BLOCK_SAFELY(completion, nil, nil, nil, nil, nil);
        return NO;
    }

    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8) {
        ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
        switch (authorizationStatus) {
            case kABAuthorizationStatusNotDetermined: {
                [[MAAlertView alertWithTitle:@"This function need to access your contacts, so I need your authorization." message:nil buttonTitle:@"Continue" buttonBlock:^{
                    [self showPeoplePickerControllerWithController:controller operationCompletion:completion onPresentCompletion:nil];
                }] show];
            } break;
            case kABAuthorizationStatusAuthorized: {
                [self showPeoplePickerControllerWithController:controller operationCompletion:completion onPresentCompletion:nil];
            } break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied:
                [self showPeoplePickerControllerWithController:controller operationCompletion:completion onPresentCompletion:^{
                    [[MAAlertView alertWithTitle:@"Access Contacts Failed!" message:@"This function need to access your contacts, please authorize to us in:\nSettings->Privacy->Contacts" buttonTitle:@"OK" buttonBlock:nil] show];
                }];
            default: {
            } break;
        }
    } else {
        [self showPeoplePickerControllerWithController:controller operationCompletion:completion onPresentCompletion:nil];
    }

    return YES;
}

- (ABPeoplePickerNavigationController *)showPeoplePickerControllerWithController:(UIViewController *)controller
                                                             operationCompletion:(ReadContactCompletion)readContactCompletion
                                                             onPresentCompletion:(void (^)(void))completion
{
    ABPeoplePickerNavigationController *addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    addressBookController.peoplePickerDelegate = self;
    self.currentSelectingController = controller;
    self.readContactCompletion = [readContactCompletion copy];
    [self.currentSelectingController presentViewController:addressBookController animated:YES completion:completion];

    return addressBookController;
}

- (void)dealWithSelectedPerson:(ABRecordRef)person
{
    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    MALogInfo(@"%@", name);

    NSMutableDictionary *phoneNumberDict = [NSMutableDictionary dictionary];
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (CFIndex index = 0; index < ABMultiValueGetCount(phoneNumbers); index++) {
        NSString *phoneLabel = CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneNumbers, index)));
        NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, index));
        if (!phoneLabel) {
            phoneLabel = @"phoneLabel";
        }
        if (phoneNumberDict[phoneLabel]) {
            phoneLabel = [NSString stringWithFormat:@"%@(%ld)", phoneLabel, index];
        }
        if (!phoneNumber) {
            phoneNumber = @"0";
        }
        phoneNumberDict[phoneLabel] = phoneNumber;
        MALogInfo(@"%@: %@", phoneLabel, phoneNumber);
    }

    NSMutableDictionary *emailDict = [NSMutableDictionary dictionary];
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (CFIndex index = 0; index < ABMultiValueGetCount(emails); index++) {
        NSString *emailLabel = CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emails, index)));
        NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emails, index));
        if (!emailLabel) {
            emailLabel = @"phoneLabel";
        }
        if (emailDict[emailLabel]) {
            emailLabel = [NSString stringWithFormat:@"%@(%ld)", emailLabel, index];
        }
        if (!email) {
            email = @"NULL";
        }
        emailDict[emailLabel] = email;
        MALogInfo(@"%@: %@", emailLabel, email);
    }

    NSDate *birthday = CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
    MALogInfo(@"%@", birthday);

    [self.currentSelectingController dismissViewControllerAnimated:YES completion:^{
        MA_INVOKE_BLOCK_SAFELY(self.readContactCompletion, name, phoneNumberDict, emailDict, birthday, nil);
        self.currentSelectingController = nil;
        self.readContactCompletion = nil;
    }];
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [self dealWithSelectedPerson:person];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dealWithSelectedPerson:person];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.currentSelectingController dismissViewControllerAnimated:YES completion:^{
        NSError *error = [NSError errorWithDomain:@"Select did canceled" code:0 userInfo:nil];
        MA_INVOKE_BLOCK_SAFELY(self.readContactCompletion, nil, nil, nil, nil, error);
        self.currentSelectingController = nil;
        self.readContactCompletion = nil;
    }];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self dealWithSelectedPerson:person];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dealWithSelectedPerson:person];
    return NO;
}

@end