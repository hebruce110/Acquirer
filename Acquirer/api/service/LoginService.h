//
//  ActivateLoginService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface LoginService : BaseService

-(void)requestForLogin;
-(void)requestForActivateLogin:(NSString *)activateSTR withPass:(NSString *)newPassSTR;

@end
