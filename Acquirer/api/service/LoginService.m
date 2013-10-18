//
//  ActivateLoginService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginService.h"
#import "Acquirer.h"
#import "AcquirerCPRequest.h"
#import "DeviceIntrospection.h"
#import "ACUser.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation LoginService

-(void)requestForLogin{
    [[Acquirer sharedInstance] showUIPromptMessage:@"登陆中..." animated:YES];
    
    ACUser *usr = [[Acquirer sharedInstance] currentUser];
    
    NSString* url = [NSString stringWithFormat:@"/user/login"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:usr.instSTR forKey:@"instId"];
    [dict setValue:usr.opratorSTR forKey:@"operId"];
    [dict setValue:[Helper md5_16:usr.passSTR] forKey:@"password"];
    [dict setValue:@"00000013" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] platformName] forKey:@"platform"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    
    NSLog(@"%@", acReq.request.url.absoluteString);
    
    [acReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [acReq execute];
}

-(void)requestForActivateLogin:(NSString *)activateSTR withPass:(NSString *)newPassSTR{
    [[Acquirer sharedInstance] showUIPromptMessage:@"登陆中..." animated:YES];
    
    ACUser *usr = [[Acquirer sharedInstance] currentUser];
    usr.passSTR = newPassSTR;
    
    NSString* url = [NSString stringWithFormat:@"/user/activateByLogin"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:usr.instSTR forKey:@"instId"];
    [dict setValue:usr.opratorSTR forKey:@"operId"];
    [dict setValue:activateSTR forKey:@"activateId"];
    [dict setValue:[Helper md5_16:usr.passSTR] forKey:@"password"];
        [dict setValue:@"00000017" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] platformName] forKey:@"platform"];
    AddOptionalReqInfomation(dict);
    
    NSLog(@"%@", dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [acReq execute];
}

-(void)loginRequestDidFinished:(AcquirerCPRequest *)req{
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (NotNilAndEqualsTo(body, @"loginFlag", @"S")) {
        ACUser *usr = [Acquirer sharedInstance].currentUser;
        usr.state = USER_STATE_ALREADY_ACTIVATED;
        usr.opratorNameSTR = [body objectForKey:@"operName"];
        usr.mobileSTR = [body objectForKey:@"mobile"];
        [usr deepCopyDevList:[body objectForKey:@"devIdList"]];
        
        //记住机构号和操作员号
        [Helper saveValue:usr.instSTR forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:usr.opratorSTR forKey:ACQUIRER_LOGIN_OPERATOR];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate loginSucceed];
        
    }else{
        //清空机构号和操作员号
        [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_OPERATOR];
    }
}

@end


















