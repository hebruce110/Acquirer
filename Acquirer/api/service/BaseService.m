//
//  BasicService.m
//  Acquirer
//
//  Created by chinaPnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"
#import "NSNotificationCenter+CP.h"
#import "ASIHTTPRequest.h"

//当前操作时间
static NSString *opreateTime(){
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//添加可选的请求信息，包括每次请求都要传递的参数
/*
 operTime | 客户端操作时间
 uid  | 手机客户端标示
 version |  版本号
 ip  |   访问服务端的ip地址
 checkValue  |   预留字符
 */
void AddOptionalReqInfomation(NSMutableDictionary *dict){
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:opreateTime() forKey:@"operTime"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
}


@implementation BaseService

- (id)onRespondTarget:(id)_target{
    target = _target;
    return self;
}

- (id)onRespondTarget:(id)_target selector:(SEL)_selector
{
	target = _target;
	selector = _selector;
	return self;
}

//ASIHTTPRequest failure callback
- (void) requestFailed:(AcquirerCPRequest *)acReq{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [acReq.request error];
    NSString *description = [error localizedDescription];
    NSLog(@"%@", description);
    
    NSLog(@"网络异常　url:%@", acReq.request.url);
    
    [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"当前网络连接异常,请检查网络再试!"
                                                                 notifyType:NOTIFICATION_TYPE_WARNING];
}

//ASIHTTPRequest failure callback
//use asihttprequest
- (void) asiRequestDidFailed:(ASIHTTPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSError *error = [req error];
    NSString *description = [error localizedDescription];
    NSLog(@"%@", description);
    
    NSLog(@"网络异常　url:%@", req.url);
    
    /*
    [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请求UID超时，请稍后再试"
                                                                 notifyType:NOTIFICATION_TYPE_WARNING];
    */
}

//默认提示超时
- (void) requestTimeOut:(AcquirerCPRequest *)req{
    [[NSNotificationCenter defaultCenter] postAutoSysPromptNotification:@"请求超时!"];
}

//处理非标准返回码
-(void) processMTPRespCode:(AcquirerCPRequest *)req{
    
}
//处理服务器返回的信息
//当返回状态码在客户端未定义,而返回的应答信息不为空
/*
- (void) processMTPRespDesc:(PosMiniCPRequest *)req{
    //do nothing here
}
*/

-(NSString *)oprateTime{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//format as yyyymmdd
-(NSString *)formatAsYMD:(NSDate *) date{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}

@end












