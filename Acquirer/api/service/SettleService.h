//
//  SettleService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"
#import "SettleQueryContent.h"

@interface SettleService : BaseService

//请求结算管理
-(void)requestForSettleManagement;

//请求结算查询
-(void)requestForSettleQuery:(NSString *)startDateSTR
                     endDate:(NSString *)endDateSTR
                  resendFlag:(NSString *)resendFlag;

//请求结算详情
-(void)requestForSettleInfo:(SettleQueryContent *)sqModel;

//请求银行结算帐户
-(void)requestForBankSettleAccount;

@end
