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
    [[Acquirer sharedInstance] hideUIPromptMessage:NO];
    
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
    [[Acquirer sharedInstance] showUIPromptMessage:@"验证中..." animated:YES];
    
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
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNil(body, @"mobile")) {
        NSString *mobileSTR = [body objectForKey:@"mobile"];
        
        if (target && [target respondsToSelector:@selector(pushToActivateViewController:)]) {
            [target performSelector:@selector(pushToActivateViewController:) withObject:mobileSTR];
        }
    }
}

-(void)requestForNewMobile:(NSString *)mobileSTR withPNRDevId:(NSString *)pnrDevIdSTR{
    [[Acquirer sharedInstance] showUIPromptMessage:@"提交中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/user/getNewMobile"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:pnrDevIdSTR forKey:@"pnrDevId"];
    [dict setValue:mobileSTR forKey:@"mobile"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:@"00000002" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    NSLog(@"%@", dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(newMobileRequestDidFinished:)];
    [acReq execute];
}

-(void)newMobileRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNilAndEqualsTo(body, @"isSucc", @"1")) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"提交成功，感谢您的反馈，我们将尽快和您联系！"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
}

#pragma mark UIAlertViewDelegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (target && [target respondsToSelector:@selector(popToRootViewController)]) {
            [target performSelector:@selector(popToRootViewController)];
        }
    }
}

@end
