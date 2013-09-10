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

@synthesize logService, msgService;

-(id)init{
    self = [super init];
    if (self != nil) {
        logService = [[LoginService alloc] init];
        msgService = [[MessageService alloc] init];
    }
    return self;
}

-(void)dealloc{
    [logService release];
    [msgService release];
    
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



















