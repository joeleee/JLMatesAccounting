//
//  MATabAccountViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabAccountViewController.h"

#import "MAGroupManager.h"
#import "MATabAccountListCell.h"
#import "MGroup.h"
#import "MATabAccountListTableHeader.h"

@interface MATabAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MATabAccountListTableHeader *tableHeaderView;

@end

@implementation MATabAccountViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [[MAGroupManager sharedManager] currentGroup];
    }

    return self;
}

- (void)loadView
{
    [super loadView];

    MGroup *currentGroup = [[MAGroupManager sharedManager] currentGroup];
    if (currentGroup) {
        self.tableHeaderView = [self tableHeaderViewWithTitle:currentGroup.groupName];
    }
    self.tableHeaderView = [self tableHeaderViewWithTitle:@"我的账户组"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setTableHeaderView:self.tableHeaderView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController setTitle:@"账目"];

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [self.tabBarController.navigationItem setLeftBarButtonItem:leftBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:rightBarItem animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"MATabAccountListCell"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [header setBackgroundColor:[UIColor redColor]];

    return header;
}

#pragma mark private

#pragma mark UI
- (MATabAccountListTableHeader *)tableHeaderViewWithTitle:(NSString *)title
{
    if (self.tableHeaderView) {
        [self.tableHeaderView setHeaderTitle:title];
    } else {
        self.tableHeaderView = [[MATabAccountListTableHeader alloc] initWithHeaderTitle:title];
    }

    return self.tableHeaderView;
}

@end
