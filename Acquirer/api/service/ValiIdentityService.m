//
//  ActivateService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-12.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ValiIdentityService.h"
#import "ASIHTTPRequest.h"
#import "Settings.h"

@implementation ValiIdentityService

-(void)requestForAuthImgURL{
    [[Acquirer sharedInstance] showUIPromptMessage:@"请求验证码..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/user/getAuthCode"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:@"00000001" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(authImgURLRequestDidFinished:)];
    [acReq execute];
}

-(void)authImgURLRequestDidFinished:(AcquirerCPRequest *)req{
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNil(body, @"imgName")) {
        NSString *imgName = [body objectForKey:@"imgName"];
        
        Settings *s = [Settings sharedInstance];
        NSString *imgPathSTR = [NSString stringWithFormat:@"%@images/%@", [s getSetting:@"server-url"], imgName];
        NSLog(@"%@", imgPathSTR);
        
        ASIHTTPRequest *authImgReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imgPathSTR]];
        [authImgReq startSynchronous];
        NSData *imgData = authImgReq.responseData;
        if (target && [target respondsToSelector:@selector(refreshAuthImgView:)]) {
            [target performSelectorOnMainThread:@selector(refreshAuthImgView:) withObject:imgData waitUntilDone:NO];
        }
    }
}

-(void)requestForValidateIdentity:(NSString *)pnrDevId withAuthCode:(NSString *)authCode{
    [[Acquirer sharedInstance] showUIPromptMessage:@"" animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/user/validateAuthCode"];
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:pnrDevId forKey:@"pnrDevId"];
    [dict setValue:authCode forKey:@"authCode"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(valiIdentityRequestDidFinished:)];
    [acReq execute];
}

-(void)valiIdentityRequestDidFinished:(AcquirerCPRequest *)req{
    NSDictionary *dict = (NSDictionary *)req.responseAsJson;
    
    
}

@end
