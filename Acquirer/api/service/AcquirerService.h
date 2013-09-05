//
//  AcquirerService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-5.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface AcquirerService : BasicService

+(AcquirerService *)sharedInstance;
+(void)destroySharedInstance;

-(void)requestForLoginCorp:(NSString *)corpSTR oprator:(NSString *)opratorSTR pass:(NSString *)passSTR;

@end
