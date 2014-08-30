//
//  MAColorDefine.h
//  MatesAccounting
//
//  Created by Joe Lee on 2014-8-25.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#define MA_COLOR_BAR_BACKGROUND     UIColorFromRGB(40,52,67)
#define MA_COLOR_VIEW_BACKGROUND    UIColorFromRGB(70,82,97)
#define MA_COLOR_BAR_TITLE          UIColorFromRGB(250,250,250)
#define MA_COLOR_BAR_ITEM           UIColorFromRGB(189,195,199)

/**
 *  MAGroup
 */
#pragma mark - Group
#define MA_COLOR_GROUP_GROUP_NAME        UIColorFromRGB(216,220,221)
#define MA_COLOR_GROUP_GROUP_TITLE       UIColorFromRGB(149,165,166)
#define MA_COLOR_GROUP_GROUP_LABEL       MA_COLOR_GROUP_GROUP_NAME
#define MA_COLOR_GROUP_COAST_FEE         UIColorFromRGB(231,76,60)

/**
 *  MATabAccount
 */
#pragma mark - MATabAccount
#define MA_COLOR_TABACCOUNT_GROUP_NAME                 UIColorFromRGB(236,240,241)
#define MA_COLOR_TABACCOUNT_TABLE_HEADER_BACKGROUND    MA_COLOR_VIEW_BACKGROUND
#define MA_COLOR_TABACCOUNT_TABLE_HEADER_SHADOW        MA_COLOR_BAR_BACKGROUND
#define MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE         UIColorFromRGB(127,140,141)
#define MA_COLOR_TABACCOUNT_ACCOUNT_DETAIL             MA_COLOR_BAR_ITEM
#define MA_COLOR_TABACCOUNT_ACCOUNT_COAST              MA_COLOR_GROUP_COAST_FEE
#define MA_COLOR_TABACCOUNT_USER_NAME                  MA_COLOR_TABACCOUNT_GROUP_NAME
#define MA_COLOR_TABACCOUNT_TIME                       MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE
#define MA_COLOR_TABACCOUNT_DIVIDING_LINE              UIColorFromRGB(65,77,92)
#define MA_COLOR_TABACCOUNT_DETAIL_INFO_TITLE          MA_COLOR_GROUP_GROUP_TITLE
#define MA_COLOR_TABACCOUNT_DETAIL_INFO_LABEL          MA_COLOR_GROUP_GROUP_NAME
#define MA_COLOR_TABACCOUNT_DETAIL_MEMBER_NULL         MA_COLOR_GROUP_GROUP_TITLE
#define MA_COLOR_TABACCOUNT_DETAIL_MEMBER_PAY          UIColorFromRGB(46,204,113)
#define MA_COLOR_TABACCOUNT_DETAIL_MEMBER_COAST        MA_COLOR_GROUP_COAST_FEE
#define MA_COLOR_TABACCOUNT_DETAIL_DESCRIPTION         MA_COLOR_GROUP_GROUP_NAME

/**
 *  MATabSettlement
 */
#pragma mark - MATabSettlement
#define MA_COLOR_TABSETTLEMENT_PAYER_NAME          MA_COLOR_TABACCOUNT_GROUP_NAME
#define MA_COLOR_TABSETTLEMENT_REVEIVER_NAME       MA_COLOR_BAR_ITEM
#define MA_COLOR_TABSETTLEMENT_SETTLTMENT_TITLE    MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE
#define MA_COLOR_TABSETTLEMENT_FEE                 MA_COLOR_TABACCOUNT_ACCOUNT_COAST
#define MA_COLOR_TABSETTLEMENT_DIVIDING_LINE       MA_COLOR_TABACCOUNT_DIVIDING_LINE

/**
 *  MATabMember
 */
#pragma mark - MATabMember
#define MA_COLOR_TABMEMBER_PAYER_NAME            MA_COLOR_TABACCOUNT_GROUP_NAME
#define MA_COLOR_TABMEMBER_BALANCE_TITLE         MA_COLOR_TABACCOUNT_TABLE_HEADER_TITLE
#define MA_COLOR_TABMEMBER_BALANCE               MA_COLOR_TABACCOUNT_ACCOUNT_COAST
#define MA_COLOR_TABMEMBER_DIVIDING_LINE         MA_COLOR_TABACCOUNT_DIVIDING_LINE
#define MA_COLOR_TABMEMBER_DETAIL_TITLE          MA_COLOR_BAR_ITEM
#define MA_COLOR_TABMEMBER_DETAIL_LABEL          MA_COLOR_TABACCOUNT_GROUP_NAME
#define MA_COLOR_TABMEMBER_DETAIL_LABEL_EDIT     MA_COLOR_TABACCOUNT_DIVIDING_LINE
#define MA_COLOR_TABMEMBER_MEMBERS_NAME          MA_COLOR_TABACCOUNT_GROUP_NAME

