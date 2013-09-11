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
        [dict objectForKey:k]!=nil && [dict objectForKey:k] != [NSNull null]){
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
    if (NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"000"))
    {
        //如果返回sessionId就做存储
        if (NotNil(body, @"sessionId")) {
            [Helper saveValue:[body valueForKey:@"sessionId"] forKey:ACQUIRER_LOCAL_SESSION_KEY];
        }
        
        //for test
        static BOOL test = YES;
        if (test) {
            test = NO;
            [[Acquirer sharedInstance] hideUIPromptMessage:YES];
            [[Acquirer sharedInstance] currentUser].state = USER_STATE_WAIT_FOR_ACTIVATE;
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_JUMP_ACTIVATE_PAGE
                                                                            object:nil
                                                                          userInfo:nil];
            return;
        }
        
        if (target && selector)
        {
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:self];
            }
        }
    }
    
    //账号未激活
    //jump to activate page
    else if (NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02127"))
    {
        
        [[Acquirer sharedInstance] currentUser].state = USER_STATE_WAIT_FOR_ACTIVATE;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:NOTIFICATION_JUMP_ACTIVATE_PAGE
                                                                        object:nil
                                                                        userInfo:nil];
        
    }
    //长时间未登录，显示是否重新登录的提示框 02110
    //已在别处登录，显示是否重新登录的提示框 02111
    //激活长时间未点提交, session超时返回 02210
    //do relogin
    else if (NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02110") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02111") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02210")){
        
    }
    //02322, 02323, 02324, 02325, 02326
    //show alert
    else if (NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02322") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02323") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02324") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02325") ||
             NotNilAndEqualsTo(body, MTP_RESPONSE_CODE, @"02326")){
        
    }
    //其他情况，只显示提示
    else{
        NSString *respDescSTR = [[Acquirer sharedInstance] respDesc:[body objectForKey:MTP_RESPONSE_CODE]];
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:respDescSTR
                                                                     notifyType:NOTIFICATION_TYPE_WARNING];
    }
    
    SEL procRespCodeMethod = @selector(processMTPRespCode:);
    if (target && [target respondsToSelector:procRespCodeMethod]) {
        [target performSelector:procRespCodeMethod withObject:self];
    }
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
}

//process failure messages dispatch
- (void) requestFailed:(ASIHTTPRequest *)request{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType) {
        if ([target respondsToSelector:@selector(requestTimeOut:)]) {
            [target performSelector:@selector(requestTimeOut:) withObject:self];
        }
    }else{
        if ([target respondsToSelector:@selector(requestFailed:)]) {
            [target performSelector:@selector(requestFailed:) withObject:self];
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

