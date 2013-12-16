//
//  ActivateLoginService.m
//  Acquirer
//
//  登录接口
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
#import "NSNotificationCenter+CP.h"

typedef enum _RequestType{
    RequestTypeLogin = 1,
    RequestTypeActivate,
}RequestType;

@implementation LoginService

//登录
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
    acReq.reqtype = RequestTypeLogin;
    
    [acReq onRespondTarget:self selector:@selector(loginRequestDidFinished:)];
    [acReq execute];
}

//登录激活
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
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    acReq.reqtype = RequestTypeActivate;
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
        usr.latestYield = [body objectForKey:@"latestYield"];
        usr.agentSlbFlag = [body objectForKey:@"agentSlbFlag"];
        usr.acctStat = [body objectForKey:@"acctStat"];
        [usr deepCopyDevList:[body objectForKey:@"devIdList"]];
        
        //记住机构号和操作员号
        [Helper saveValue:usr.instSTR forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:usr.opratorSTR forKey:ACQUIRER_LOGIN_OPERATOR];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate loginSucceed];
        
    }else if(NotNilAndEqualsTo(body, @"loginFlag", @"I")){
        //清空机构号和操作员号
        /*
        [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_OPERATOR];
         */
        //登录未激活
        if (req.reqtype == RequestTypeLogin) {
            
            if (target && [target respondsToSelector:@selector(LoginForActivate:)]) {
                [target performSelector:@selector(LoginForActivate:) withObject:[body objectForKey:@"mobile"]];
            }
            
        }
        //激活页面返回的状态还是未激活
        else if (req.reqtype == RequestTypeActivate){
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"激活失败"
                                                                         notifyType:NOTIFICATION_TYPE_WARNING];
        }
    }
}

//账号激活
- (void)requestForActivateByActivateId:(NSString *)activateId pnrDevIdSTR:(NSString *)pnrDevIdSTR password:(NSString *)password
{
    [[Acquirer sharedInstance] showUIPromptMessage:@"验证中..." animated:YES];
    
    ACUser *usr = [[Acquirer sharedInstance] currentUser];
    usr.passSTR = password;
    
    NSString* url = [NSString stringWithFormat:@"/user/accountActivate"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:pnrDevIdSTR forKey:@"pnrDevId"];
    [dict setValue:usr.instSTR forKey:@"instId"];
    [dict setValue:usr.opratorSTR forKey:@"operId"];
    [dict setValue:activateId forKey:@"activateId"];
    [dict setValue:[Helper md5_16:password] forKey:@"password"];
    [dict setValue:@"00000003" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] platformName] forKey:@"platform"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    acReq.reqtype = RequestTypeActivate;
    [acReq onRespondTarget:self selector:@selector(requestForActivateDidFinished:)];
    [acReq execute];
}

- (void)requestForActivateDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    
    if (NotNilAndEqualsTo(body, @"loginFlag", @"S")) {
        ACUser *usr = [Acquirer sharedInstance].currentUser;
        usr.state = USER_STATE_ALREADY_ACTIVATED;
        usr.opratorNameSTR = [body objectForKey:@"operName"];
        usr.mobileSTR = [body objectForKey:@"mobile"];
        usr.latestYield = [body objectForKey:@"latestYield"];
        usr.agentSlbFlag = [body objectForKey:@"agentSlbFlag"];
        usr.acctStat = [body objectForKey:@"acctStat"];
        [usr deepCopyDevList:[body objectForKey:@"devIdList"]];
        
        //记住机构号和操作员号
        [Helper saveValue:usr.instSTR forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:usr.opratorSTR forKey:ACQUIRER_LOGIN_OPERATOR];
        
        if(target && [target respondsToSelector:@selector(backToLoginViewCtrl)])
        {
            [target performSelectorOnMainThread:@selector(backToLoginViewCtrl) withObject:nil waitUntilDone:YES];
        }
    }else if(NotNilAndEqualsTo(body, @"loginFlag", @"I")){
        //清空机构号和操作员号
        /*
         [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_INSTITUTE];
         [Helper saveValue:@"" forKey:ACQUIRER_LOGIN_OPERATOR];
         */
        //登录未激活
        if (request.reqtype == RequestTypeLogin) {
            
            if (target && [target respondsToSelector:@selector(LoginForActivate:)]) {
                [target performSelector:@selector(LoginForActivate:) withObject:[body objectForKey:@"mobile"]];
            }
        }
        //激活页面返回的状态还是未激活
        else if (request.reqtype == RequestTypeActivate){
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"激活失败"
                                                                         notifyType:NOTIFICATION_TYPE_WARNING];
        }
    }
    else //if(request.reqtype == RequestTypeActivate)
    {
        [[Acquirer sharedInstance] hideUIPromptMessage:YES];
        
        //记住机构号和操作员号
        NSString *instSTR = [body objectForKey:@"instId"];
        NSString *opratorSTR = [body objectForKey:@"operId"];
        
        [Helper saveValue:instSTR forKey:ACQUIRER_LOGIN_INSTITUTE];
        [Helper saveValue:opratorSTR forKey:ACQUIRER_LOGIN_OPERATOR];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.loginNavi popToRootViewControllerAnimated:YES];
    }
}

@end

