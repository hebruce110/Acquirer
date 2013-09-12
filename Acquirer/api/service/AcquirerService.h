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
#import "ValiIdentityService.h"
#import "PostbeService.h"

@interface AcquirerService : BaseService{
    PostbeService *postbeService;
    LoginService *logService;
    MessageService *msgService;
    ValiIdentityService *valiService;
}

@property (nonatomic, readonly) PostbeService *postbeService;
@property (nonatomic, readonly) LoginService *logService;
@property (nonatomic, readonly) MessageService *msgService;
@property (nonatomic, readonly) ValiIdentityService *valiService;

+(AcquirerService *)sharedInstance;
+(void)destroySharedInstance;

@end
