//
//  AcquirerCPRequest.m
//  Acquirer
//
//  Created by chinapnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AcquirerCPRequest.h"
#import "NSNotificationCenter+CP.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Helper.h"
#import "Acquirer.h"

//avoid serverside return nil, lead to app crash
//JSON assign null value as [NSNull null], totally different from nil or NULL
BOOL NotNil(id dict, NSString *k){
    if (dict!=nil && [dict isKindOfClass:[NSDictionary class]] &&
        [dict objectForKey:k]!=nil && [dict objectForKey:k] != [NSNull null])
    {
        return YES;
    }
    return NO;
}

//avoid serverside return nil, lead to app crash
BOOL NotNilAndEqualsTo(id dict, NSString *k, NSString *value){
    if (NotNil(dict, k) && [[NSString stringWithFormat:@"%@", [dict valueForKey:k]] isEqualToString:value]) {
        return YES;
    }
    return NO;
}

@implementation AcquirerCPRequest

@synthesize reqtype, userInfo;
@synthesize respDesc;

-(void)dealloc{
    [userInfo release];
    [respDesc release];
    [super dealloc];
}

-(id)initWithTarget:(id)_target{
    self = [super init];
    if (self) {
        target = _target;
        selector = @selector(requestFinished:);
    }
    return self;
}

-(void)execute{
    
    [self onRespondJSON:self];
    
    [[Acquirer sharedInstance] performRequest:self.request];
    
    [super execute];
}


- (void)onResponseText:(NSString *)body withResponseCode:(unsigned int)responseCode
{
    [self onRespondText:nil];
    
    if (target && selector)
	{
        if ([target respondsToSelector:selector]) {
            [target performSelector:selector withObject:self];
        }
	}
}

- (void)onResponseJSON:(id)body withResponseCode:(unsigned int)responseCode
{
    [self onRespondJSON:nil];
    
    NSLog(@"%@", body);
    //统一判断状态码返回
    //状态码返回成功
    if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"000"))
    {
        //如果返回sessionId就做存储
        if (NotNil(body, @"SessionId")) {
            [Helper saveValue:[body valueForKey:@"SessionId"] forKey:ACQUIRER_LOCAL_SESSION_KEY];
        }
        
        if (target && selector)
        {
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:self];
            }
        }
    }
    //需要重新登录建立session
    else if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"899"))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUIRE_USER_LOGIN object:nil];
        
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"长时间未使用，请重新登录!"];
        //[[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回出错,打印出错信息
    else if (NotNilAndEqualsTo(body, MTP_POS_RESPONSE_CODE, @"881"))
    {
        //当然用户尚未绑定设备
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"当前用户未绑定设备"];
        //[[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回未定义状态码,提示服务器返回信息
    else if (NotNil(body, @"RespDesc"))
    {
        self.respDesc = [body objectForKey:@"RespDesc"];
        if (target && [target respondsToSelector:@selector(processMTPRespDesc:)]) {
            [target performSelector:@selector(processMTPRespDesc:) withObject:self];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_UI_PROMPT object:nil];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:[body objectForKey:@"RespDesc"]];
        //[[PosMini sharedInstance] hideUIPromptMessage:YES];
    }
    //返回内容非JSON格式
    else{
        //[[PosMini sharedInstance] hideUIPromptMessage:YES];
        [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"服务端返回数据异常"];
    }
}

//process failure messages dispatch
- (void) requestFailed:(ASIHTTPRequest *)request{
    //[[PosMini sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType) {
        if ([target respondsToSelector:@selector(requestTimeOut:)]) {
            [target performSelector:@selector(requestTimeOut:) withObject:self];
        }
    }
}

-(void)setDidFinishSelector:(SEL)_selector{
    selector = _selector;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

@end

