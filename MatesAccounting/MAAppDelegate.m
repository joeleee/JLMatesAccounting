//
//  MAAppDelegate.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAAppDelegate.h"

#import "MAContextAPI.h"
#import "MARootNavigationControllerDelegate.h"

@interface MAAppDelegate ()

@end

@implementation MAAppDelegate

void uncaughtExceptionHandler(NSException *exception)
{
    MALogError(@"CRASH: %@", exception);
    MALogError(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [[MAContextAPI sharedAPI] saveContextData];
    [self.window makeKeyAndVisible];

    // Set rootNavigaionController's delegate
    id rootNavigationController = self.window.rootViewController;
    MA_QUICK_ASSERT([rootNavigationController isKindOfClass:UINavigationController.class], @"Wrong root navigation controller!");
    [(UINavigationController *)rootNavigationController setDelegate:[MARootNavigationControllerDelegate sharedDelegate]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[MAContextAPI sharedAPI] saveContextData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[MAContextAPI sharedAPI] saveContextData];
}

@end