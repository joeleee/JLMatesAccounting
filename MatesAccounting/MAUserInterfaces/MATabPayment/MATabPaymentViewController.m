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
#import "MFriend.h"
#import "MATabTableView.h"

NSString * const kSegueTabPaymentToGroupList = @"kSegueTabPaymentToGroupList";


@interface MATabPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MAAccountManagerObserverProtocol, MAGroupManagerObserverProtocol>

@property (weak, nonatomic) IBOutlet MATabTableView *tableView;
@property (nonatomic, strong) NSArray *settlementList;
@property (nonatomic, assign) BOOL needReloadDataWhenAppear;

@end


@implementation MATabPaymentViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
        [AccountManager registerGroupObserver:self];
        [GroupManager registerGroupObserver:self];
        self.needReloadDataWhenAppear = NO;
    }

    return self;
}

- (void)dealloc
{
    [AccountManager unregisterGroupObserver:self];
    [GroupManager unregisterGroupObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:MA_COLOR_VIEW_BACKGROUND];
    [self.tableView setContentInset:self.tableView.contentInset];
    [self.tableView scrollToFirstRow:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tableView setContentInset:self.tableView.contentInset];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"Debt List"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didRefreshNavigationButtonTapped:)];
    [self.tabBarController.navigationItem setLeftBarButtonItem:viewGroupBarItem animated:YES];
    [self.tabBarController.navigationItem setRightBarButtonItem:refreshBarItem animated:YES];

    if (self.needReloadDataWhenAppear) {
        self.needReloadDataWhenAppear = NO;
        [self loadData];
        [self.tableView reloadDataWithAnimation:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.tableView.contentOffset.y < -self.tableView.contentInset.top) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, -self.tableView.contentInset.top) animated:animated];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueTabPaymentToGroupList]) {
    }
}

- (void)loadData
{
    self.settlementList = [AccountManager accountSettlementListForGroup:MACurrentGroup];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settlementList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAAccountSettlementCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAAccountSettlementCell className]];

    if (self.settlementList.count <= indexPath.row) {
        MA_ASSERT_FAILED(@"Array out of bounds!");
        return cell;
    }

    [cell reuseCellWithData:self.settlementList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.settlementList.count <= indexPath.row) {
        MA_ASSERT_FAILED(@"Array out of bounds!");
        return 0;
    }

    return [MAAccountSettlementCell cellHeight:self.settlementList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.settlementList.count <= indexPath.row) {
        MA_ASSERT_FAILED(@"Array out of bounds!");
        return;
    }

    MAAccountSettlement *settlement = self.settlementList[indexPath.row];
    NSString *actionTitle = [NSString stringWithFormat:@"%@ needs to pay %@ %@ to pay off the debt", settlement.fromMember.name, settlement.toMember.name, settlement.fee];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Liquidation of Debt", nil];
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if (self.settlementList.count <= actionSheet.tag) {
            MA_ASSERT_FAILED(@"Array out of bounds!");
            return;
        }

        MAAccountSettlement *settlement = self.settlementList[actionSheet.tag];
        if ([settlement.fee isEqualToNumber:[NSDecimalNumber notANumber]]) {
            settlement.fee = DecimalZero;
        }

        NSDecimalNumber *fee = (NSOrderedDescending == [settlement.fee compare:DecimalZero]) ? settlement.fee : [settlement.fee inverseNumber];
        MAFeeOfMember *payer = [MAFeeOfMember feeOfMember:settlement.fromMember fee:fee];
        MAFeeOfMember *receiver = [MAFeeOfMember feeOfMember:settlement.toMember fee:[fee inverseNumber]];
        NSString *detail = [NSString stringWithFormat:@"Repayment from %@ to %@", settlement.fromMember.name, settlement.toMember.name];

        MAccount *account = [[MAAccountManager sharedManager] createAccountWithGroup:MACurrentGroup date:[NSDate date] placeName:nil location:nil detail:detail feeOfMembers:[NSSet setWithObjects:payer, receiver, nil]];
        if (account) {
            [self loadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [[MAAlertView alertWithTitle:@"Repayment Failed" message:nil buttonTitle:@"OK" buttonBlock:^{ }] show];
        }
    }
}


#pragma mark - MAAccountManagerObserverProtocol

- (void)accountDidChanged:(MAccount *)account
{
    if (![self isTopViewController]) {
        self.needReloadDataWhenAppear = YES;
        return;
    }

    [self loadData];
    [self.tableView reloadData];
}

- (void)accountDidCreated:(MAccount *)account
{
    if (![self isTopViewController]) {
        self.needReloadDataWhenAppear = YES;
        return;
    }

    [self loadData];
    [self.tableView reloadData];
}

- (void)accountDidDeletedInGroup:(MGroup *)group
{
    if (MACurrentGroup == group) {
        if (![self isTopViewController]) {
            self.needReloadDataWhenAppear = YES;
            return;
        }

        [self loadData];
        [self.tableView reloadData];
    }
}


#pragma mark - MAGroupManagerObserverProtocol

- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd
{
    if (group == MACurrentGroup) {
        if (![self isTopViewController]) {
            self.needReloadDataWhenAppear = YES;
            return;
        }

        [self loadData];
        [self.tableView reloadData];
    }
}

- (void)currentGroupDidSwitched:(MGroup *)group
{
    [self.tableView scrollToFirstRow:NO];
    if (![self isTopViewController]) {
        self.needReloadDataWhenAppear = YES;
        return;
    }

    [self loadData];
    [self.tableView reloadData];
}


#pragma mark UI action

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabPaymentToGroupList sender:MACurrentGroup];
}

- (void)didRefreshNavigationButtonTapped:(id)sender
{
    [self loadData];
    [self.tableView reloadDataWithAnimation:YES];
}

@end