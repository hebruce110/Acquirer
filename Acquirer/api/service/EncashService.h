//
//  EncashService.h
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface EncashService : BaseService

//对即时结算进行鉴权，判断用户状态是否正常，是否能进行即时结算操作，用户是否签订了协议
-(void)requestForBalanceAuth;

//请求同意协议
-(void)requestForProtocalAgreement;

@end
