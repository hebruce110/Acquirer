//
//  ActivateLoginService.h
//  Acquirer
//
//  登录接口
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface LoginService : BaseService

//登录
-(void)requestForLogin;

//登录激活
-(void)requestForActivateLogin:(NSString *)activateSTR withPass:(NSString *)newPassSTR;

//账号激活
- (void)requestForActivateByActivateId:(NSString *)activateId pnrDevIdSTR:(NSString *)pnrDevIdSTR password:(NSString *)password;

@end
