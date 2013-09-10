//
//  AcquirerService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-5.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

#import "LoginService.h"
#import "MessageService.h"

@interface AcquirerService : BaseService{
    LoginService *logService;
    MessageService *msgService;
}

@property (nonatomic, readonly) LoginService *logService;
@property (nonatomic, readonly) MessageService *msgService;

+(AcquirerService *)sharedInstance;
+(void)destroySharedInstance;

@end
