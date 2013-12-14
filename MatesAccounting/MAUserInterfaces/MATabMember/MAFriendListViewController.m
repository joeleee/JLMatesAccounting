//
//  MAFriendListViewController.m
//  MatesAccounting
//
//  Created by Lee on 13-12-14.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "MAFriendListViewController.h"

#import "MAFriendListCell.h"
#import "MAMemberDetailViewController.h"

NSString * const kSegueFriendListToCreateMember = @"kSegueFriendListToCreateMember";

@interface MAFriendListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *createFriendBarItem;
@property (nonatomic, strong) UIBarButtonItem *selectDoneBarItem;

@end

@implementation MAFriendListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueFriendListToCreateMember]) {
        NSAssert(0 < [segue.destinationViewController viewControllers].count, @"present MAAccountDetailViewController error!");
        MAMemberDetailViewController *memberDetail = [segue.destinationViewController viewControllers][0];
        [memberDetail setIsCreateMode:YES];
    } else {
        NSAssert(NO, @"Unknow segue - MAFriendListViewController");
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAFriendListCell className]];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 18;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.navigationItem rightBarButtonItem] != self.selectDoneBarItem) {
        [self.navigationItem setRightBarButtonItem:self.selectDoneBarItem animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 >= [[tableView indexPathsForSelectedRows] count]) {
        [self.navigationItem setRightBarButtonItem:self.createFriendBarItem animated:YES];
    }
}

#pragma mark @property method
- (UIBarButtonItem *)createFriendBarItem
{
    if (_createFriendBarItem) {
        return _createFriendBarItem;
    }

    _createFriendBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didCreateNavigationButtonTaped:)];
    return _createFriendBarItem;
}

- (UIBarButtonItem *)selectDoneBarItem
{
    if (_selectDoneBarItem) {
        return _selectDoneBarItem;
    }

    _selectDoneBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDoneNavigationButtonTaped:)];
    return _selectDoneBarItem;
}

#pragma mark UI action
- (void)didCreateNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self performSegueWithIdentifier:kSegueFriendListToCreateMember sender:nil];
}

- (void)didSelectDoneNavigationButtonTaped:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end