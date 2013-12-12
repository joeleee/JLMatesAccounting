//
//  MATabMemberViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MATabMemberViewController.h"

#import "MAGroupManager.h"
#import "MAMemberDetailViewController.h"
#import "MATabMemberListCell.h"
#import "MAMemberManager.h"

NSString * const kSegueTabMemberToGroupList = @"kSegueTabMemberToGroupList";
NSString * const kSegueTabMemberToMemberDetail = @"kSegueTabMemberToMemberDetail";
NSString * const kSegueTabMemberToCreateMember = @"kSegueTabMemberToCreateMember";

@interface MATabMemberViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MATabMemberViewController

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

    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -64);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController setTitle:@"成员"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(didGroupNavigationButtonTaped:)];
    UIBarButtonItem *addMemberBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didAddMemberNavigationButtonTaped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:addMemberBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabMemberToGroupList]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToMemberDetail]) {
    } else if ([segue.identifier isEqualToString:kSegueTabMemberToCreateMember]) {
        NSAssert(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setIsCreateMode:YES];
    } else {
        NSAssert(NO, @"Wrong segue! (MATabMemberViewController)");
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MATabMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MATabMemberListCell className]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rowCount = [memberManager currentGroupMembers].count;

    // TODO: test data
    rowCount = 18;

    return rowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSegueTabMemberToMemberDetail sender:nil];
}

#pragma mark - private method

#pragma mark data
- (void)loadData
{
    [memberManager currentGroupMembers];
}

#pragma mark action

- (void)didGroupNavigationButtonTaped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueTabMemberToGroupList sender:[GroupManager currentGroup]];
}

- (void)didAddMemberNavigationButtonTaped:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:kSegueTabMemberToCreateMember sender:nil];
}

@end