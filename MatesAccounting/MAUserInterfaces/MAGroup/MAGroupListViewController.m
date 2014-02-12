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

@interface MAGroupListViewController () <UITableViewDataSource, UITableViewDelegate, MACellActionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MAGroupListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(groupHasCreated:)
                                                     name:MAGroupManagerGroupHasCreated
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(groupHasModified:)
                                                     name:MAGroupManagerGroupHasModified
                                                   object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        MAGroupDetailViewController *controller = segue.destinationViewController;
        controller.isCreateMode = NO;
        controller.group = sender;
    } else if ([segue.identifier isEqualToString:kSegueGroupListToCreateGroup]) {
        MAGroupDetailViewController *controller = segue.destinationViewController;
        controller.isCreateMode = YES;
        controller.group = nil;
    } else {
        NSAssert(NO, @"Unknow segue ? MAGroupListViewController");
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
        NSAssert(NO, @"index beyond of group list count");
        return cell;
    }

    MGroup *group = [GroupManager myGroups][indexPath.row];
    [cell reuseCellWithData:group];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [GroupManager myGroups].count) {
        NSAssert(NO, @"index beyond of group list count");
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
        NSAssert(NO, @"Unknow action? MAGroupListViewController - actionWithData");
    }

    return YES;
}

#pragma mark - notifications

- (void)groupHasModified:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)groupHasCreated:(NSNotification *)notification
{
    [self.tableView reloadData];
}

@end