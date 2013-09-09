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

static AcquirerService *sInstance = nil;

@implementation AcquirerService

+(AcquirerService *)sharedInstance{
    if (sInstance == nil) {
        sInstance = [[AcquirerService alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

-(void)requestForLogin{
    [[Acquirer sharedInstance] showUIPromptMessage:@"登陆中..." animated:YES];
    
    ACUser *usr = [[Acquirer sharedInstance] currentUser];
    
    NSString* url = [NSString stringWithFormat:@"/user/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:usr.instSTR forKey:@"instId"];
    [dict setValue:usr.opratorSTR forKey:@"operId"];
    [dict setValue:[Helper md5_16:usr.passSTR] forKey:@"password"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[[DeviceIntrospection sharedInstance] uuid] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:@"00000013" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    [dict setValue:[[DeviceIntrospection sharedInstance] platformName] forKey:@"platform"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [acReq execute];
}

-(void)loginRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNilAndEqualsTo(body, @"loginFlag", @"S")) {
        [Acquirer sharedInstance].currentUser.state = USER_STATE_ALREADY_ACTIVATED;
        
        
    }
}

@end








