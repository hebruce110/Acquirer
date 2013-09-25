//
//  ActivateService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface ValiIdentityService : BaseService<UIAlertViewDelegate>

//请求验证码图片地址
-(void)requestForAuthImgURL;

//验证身份请求
-(void)requestForValidateIdentity:(NSString *)pnrDevId withAuthCode:(NSString *)authCode;

//请求修改手机号
-(void)requestForNewMobile:(NSString *)mobileSTR withPNRDevId:(NSString *)pnrDevIdSTR;

@end
