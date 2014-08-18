//
//  MATabMoreViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMoreViewController.h"

#import "MATestDataGenerater.h"

@interface MATabMoreViewController ()

@end

@implementation MATabMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"More"];

    UIBarButtonItem *deleteAllTestDataBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didDeleteAllTestDataBarButtonTaped:)];
    UIBarButtonItem *generateTestDataBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(didGenerateTestDataBarButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:deleteAllTestDataBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:generateTestDataBarItem animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didDeleteAllTestDataBarButtonTaped:(id)sender
{
    [[MATestDataGenerater instance] clearAllData];
}

- (void)didGenerateTestDataBarButtonTaped:(id)sender
{
    [[MATestDataGenerater instance] onePackageService];
}

@end
