//
//  SettleService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SettleService : BaseService

//请求结算管理
-(void)requestForSettleManagement;

//请求结算查询
-(void)requestForSettleQuery:(NSString *)startDateSTR
                     endDate:(NSString *)endDateSTR
                  resendFlag:(NSString *)resendFlag;

@end
