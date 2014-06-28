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
#import "MAGroupDetailViewController.h"

NSString * const kSegueGroupListToGroupDetail = @"kSegueGroupListToGroupDetail";
NSString * const kSegueGroupListToCreateGroup = @"kSegueGroupListToCreateGroup";

@interface MAGroupListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate, MAGroupManagerListenerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *groupList;

@end

@implementation MAGroupListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)dealloc
{
}

- (void)loadView
{
    [super loadView];

    UIBarButtonItem *addGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupNavigationButtonTaped:)];
    [self.navigationItem setRightBarButtonItem:addGroupBarItem animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueGroupListToGroupDetail]) {
        MAGroupDetailViewController *controller = segue.destinationViewController;
        [controller setGroup:sender];
    } else if ([segue.identifier isEqualToString:kSegueGroupListToCreateGroup]) {
        MAGroupDetailViewController *controller = segue.destinationViewController;
        [controller setGroup:nil];
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow segue ? MAGroupListViewController");
    }
}

- (void)loadData
{
    self.groupList = [GroupManager myGroups];
    if (1 == self.tableView.numberOfSections) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GroupManager myGroups].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAGroupListCell reuseIdentifier]];
    cell.actionDelegate = self;

    if (indexPath.row >= [GroupManager myGroups].count) {
        MA_QUICK_ASSERT(NO, @"index beyond of group list count");
        return cell;
    }

    MGroup *group = [GroupManager myGroups][indexPath.row];
    [cell reuseCellWithData:group];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [GroupManager myGroups].count) {
        MA_QUICK_ASSERT(NO, @"index beyond of group list count");
        return;
    }

    MGroup *group = [GroupManager myGroups][indexPath.row];
    if ([GroupManager changeGroup:group]) {
        [self.navigationController popViewControllerAnimated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action
- (void)addGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueGroupListToCreateGroup sender:nil];
}

#pragma mark - MACellActionDelegate
- (BOOL)actionWithData:(id)data cell:(UITableViewCell *)cell type:(NSInteger)type
{
    if ([cell isKindOfClass:[MAGroupListCell class]]) {
        [self performSegueWithIdentifier:kSegueGroupListToGroupDetail sender:data];
    } else {
        MA_QUICK_ASSERT(NO, @"Unknow action? MAGroupListViewController - actionWithData");
    }

    return YES;
}

#pragma mark - MAGroupManagerListenerProtocol

- (void)groupHasCreated:(MGroup *)group
{
    [self loadData];
}

- (void)groupHasModified:(MGroup *)group
{
    [self loadData];
}

@end