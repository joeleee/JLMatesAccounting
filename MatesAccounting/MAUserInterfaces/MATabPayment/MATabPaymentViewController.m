//
//  MATabPaymentViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabPaymentViewController.h"

#import "MAGroupManager.h"
#import "MAAccountManager.h"
#import "MAAccountSettlementCell.h"

NSString * const kSegueTabPaymentToGroupList = @"kSegueTabPaymentToGroupList";

@interface MATabPaymentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *settlementList;

@end

@implementation MATabPaymentViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    UIEdgeInsets tableViewEdgeInsets = UIEdgeInsetsMake(MA_STATUSBAR_HEIGHT + MA_NAVIGATIONBAR_HEIGHT, 0.0f, MA_TABBAR_HEIGHT, 0.0f);
    [self.tableView setContentInset:tableViewEdgeInsets];
    [self.tableView setScrollIndicatorInsets:tableViewEdgeInsets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"结算"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:refreshBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabPaymentToGroupList]) {
    }
}

- (void)loadData
{
    self.settlementList = [AccountManager accountSettlementListForGroup:MASelectedGroup];
}

#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settlementList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAAccountSettlementCell className]];

    return cell;
}

#pragma mark - UI action

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabPaymentToGroupList sender:MASelectedGroup];
}

@end