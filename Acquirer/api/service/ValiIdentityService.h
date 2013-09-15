//
//  ActivateService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface ValiIdentityService : BaseService<UIAlertViewDelegate>

-(void)requestForAuthImgURL;

-(void)requestForValidateIdentity:(NSString *)pnrDevId withAuthCode:(NSString *)authCode;

-(void)requestForNewMobile:(NSString *)mobileSTR withPNRDevId:(NSString *)pnrDevIdSTR;

@end
