//
//  ActivateLoginService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BasicService.h"

@interface ActivateLoginService : BasicService

-(void)requestForActivateLogin:(NSString *)activateSTR withPass:(NSString *)newPassSTR;

@end
