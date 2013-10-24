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
#import "CodeCSVService.h"
#import "SummaryService.h"
#import "DetailService.h"
#import "SettleService.h"
#import "EncashService.h"

@interface AcquirerService : NSObject{
    PostbeService *postbeService;
    LoginService *logService;
    MessageService *msgService;
    ValiIdentityService *valiService;
    CodeCSVService *codeCSVService;
    SummaryService *sumService;
    DetailService *detailService;
    SettleService *settleService;
    EncashService *encashService;
}

@property (nonatomic, readonly) PostbeService *postbeService;
@property (nonatomic, readonly) LoginService *logService;
@property (nonatomic, readonly) MessageService *msgService;
@property (nonatomic, readonly) ValiIdentityService *valiService;
@property (nonatomic, readonly) CodeCSVService *codeCSVService;
@property (nonatomic, readonly) SummaryService *sumService;
@property (nonatomic, readonly) DetailService *detailService;
@property (nonatomic, readonly) SettleService *settleService;
@property (nonatomic, readonly) EncashService *encashService;

+(AcquirerService *)sharedInstance;
+(void)destroySharedInstance;

@end
