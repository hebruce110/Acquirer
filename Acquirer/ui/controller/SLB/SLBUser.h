//
//  SLBUser.h
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

//生利宝用户信息
/*
 账户状态      acctStat
 当前待结算资金 settleFund
 生利宝总金额   totalAsset
 当日收益      curProfit
 历史累计收益	totalProfit
 最低转入金额	minIn
 最高转入金额	maxIn
 最低转出金额	minOut
 最高转出金额	maxOut
 服务提供方	prodiderName
 姓名         fullName
 证件类型       certType
 证件号码       certNo
 银行卡号       cardNo
 手机号        mobile
*/
@interface SLBUser : NSObject

- (id)objectForKey:(id)aKey;
- (id)safeObjectForKey:(id)aKey;

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
