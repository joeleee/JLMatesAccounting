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

NSString * const kSegueTabPaymentToGroupList = @"kSegueTabPaymentToGroupList";


@interface MATabPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MAAccountManagerObserverProtocol, MAGroupManagerObserverProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *settlementList;

@end


@implementation MATabPaymentViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadData];
        [AccountManager registerGroupObserver:self];
        [GroupManager registerGroupObserver:self];
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
    [self.tabBarController setTitle:@"Pay Settlement"];

    UIBarButtonItem *viewGroupBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewGroupNavigationButtonTaped:)];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didRefreshNavigationButtonTapped:)];
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
    self.settlementList = [AccountManager accountSettlementListForGroup:MACurrentGroup];
    [self.tableView reloadData];
}


#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settlementList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MAAccountSettlementCell *cell = [tableView dequeueReusableCellWithIdentifier:[MAAccountSettlementCell className]];

    MA_QUICK_ASSERT(self.settlementList.count > indexPath.row, @"Array out of bounds!");
    [cell reuseCellWithData:self.settlementList[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_QUICK_ASSERT(self.settlementList.count > indexPath.row, @"Array out of bounds!");
    return [MAAccountSettlementCell cellHeight:self.settlementList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MA_QUICK_ASSERT(self.settlementList.count > indexPath.row, @"Array out of bounds!");

    MAAccountSettlement *settlement = self.settlementList[indexPath.row];
    NSString *actionTitle = [NSString stringWithFormat:@"%@ needs to pay %@ back %@ to settle this accounts", settlement.fromMember.name, settlement.toMember.name, settlement.fee];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Repayment", nil];
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        MA_QUICK_ASSERT(self.settlementList.count > actionSheet.tag, @"Array out of bounds!");
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
        } else {
            [[MAAlertView alertWithTitle:@"Repayment Failed" message:nil buttonTitle:@"OK" buttonBlock:^{ }] show];
        }
    }
}


#pragma mark - MAAccountManagerObserverProtocol

- (void)accountDidChanged:(MAccount *)account
{
    [self loadData];
}

- (void)accountDidCreated:(MAccount *)account
{
    [self loadData];
}

- (void)accountDidDeletedInGroup:(MGroup *)group
{
    if (MACurrentGroup == group) {
        [self loadData];
    }
}


#pragma mark - MAGroupManagerObserverProtocol

- (void)groupMemberDidChanged:(MGroup *)group member:(MFriend *)mFriend isAdd:(BOOL)isAdd
{
    if (group == MACurrentGroup) {
        [self loadData];
    }
}

- (void)currentGroupDidSwitched:(MGroup *)group
{
    [self loadData];
}


#pragma mark UI action

- (void)viewGroupNavigationButtonTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueTabPaymentToGroupList sender:MACurrentGroup];
}

- (void)didRefreshNavigationButtonTapped:(id)sender
{
    [self loadData];
}

@end