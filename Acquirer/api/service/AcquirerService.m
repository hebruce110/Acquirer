//
//  AcquirerService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-5.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AcquirerService.h"
#import "Acquirer.h"
#import "AcquirerCPRequest.h"
#import "DeviceIntrospection.h"
#import "ACUser.h"
#import "AppDelegate.h"

static AcquirerService *sInstance = nil;

@implementation AcquirerService

@synthesize postbeService, logService, msgService;
@synthesize valiService, codeCSVService, sumService;
@synthesize detailService;

-(id)init{
    self = [super init];
    if (self != nil) {
        postbeService = [[PostbeService alloc] init];
        logService = [[LoginService alloc] init];
        msgService = [[MessageService alloc] init];
        valiService = [[ValiIdentityService alloc] init];
        codeCSVService = [[CodeCSVService alloc] init];
        sumService = [[SummaryService alloc] init];
        detailService = [[DetailService alloc] init];
    }
    return self;
}

-(void)dealloc{
    [postbeService release];
    [logService release];
    [msgService release];
    [valiService release];
    [codeCSVService release];
    [sumService release];
    [detailService release];
    [super dealloc];
}

+(AcquirerService *)sharedInstance{
    if (sInstance == nil) {
        sInstance = [[AcquirerService alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

@end



















