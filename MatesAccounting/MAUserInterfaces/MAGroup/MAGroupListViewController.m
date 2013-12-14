//
//  MAGroupListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-28.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAGroupListViewController.h"

#import "MAGroupManager.h"
#import "MAGroupListCell.h"

NSString * const kSegueGroupListToGroupDetail = @"kSegueGroupListToGroupDetail";
NSString * const kSegueGroupListToCreateGroup = @"kSegueGroupListToCreateGroup";

@interface MAGroupListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MAGroupListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
    }

    return self;
}

- (void)loadView
{
    [super loadView];

    UIBarButtonItem *addGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupNavigationButtonTaped:)];
    [self.navigationItem setRightBarButtonItem:addGroupBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueGroupListToGroupDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueGroupListToCreateGroup]) {
    } else {
        NSAssert(NO, @"Unknow segue ? MAGroupListViewController");
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    // TODO:
    // return [GroupManager myGroups].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAGroupListCell reuseIdentifier]];
    cell.actionDelegate = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: change group
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private

#pragma mark data
- (void)loadData
{
    [GroupManager myGroups];
}

#pragma mark action
- (void)addGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueGroupListToCreateGroup sender:nil];
}

#pragma mark MACellActionDelegate
- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    if ([cell isKindOfClass:[MAGroupListCell class]]) {
        [self performSegueWithIdentifier:kSegueGroupListToGroupDetail sender:nil];
    } else {
        NSAssert(NO, @"Unknow action? MAGroupListViewController - actionWithData");
    }

    return YES;
}

@end