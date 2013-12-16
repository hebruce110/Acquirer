//
//  OnlineService.m
//  Acquirer
//
//  Created by soal on 13-11-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "OnlineService.h"

@implementation OnlineService

//报表信息查询
- (void)requestReportListTarget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    
    NSString* url = [NSString stringWithFormat:@"/report/queryReportList"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestReportListDidFinished:)];
    [acReq execute];
}

- (void)requestReportListDidFinished:(AcquirerCPRequest *)request
{
    if(target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:request];
    }
}

//报表信息更新接口
- (void)requestUpdateReportInfoByFlag:(NSString *)flag reportType:(NSString *)reportType isSubscribe:(NSString *)isSubscribe target:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    
    if(isSubscribe && [isSubscribe isEqualToString:@"N"]) {
        [ac showUIPromptMessage:@"取消订阅..." animated:YES];
    }
    else if(isSubscribe && [isSubscribe isEqualToString:@"Y"]) {
        [ac showUIPromptMessage:@"订阅报表..." animated:YES];
    }
    
    NSString* url = [NSString stringWithFormat:@"/report/updateReportInfo"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:flag forKey:@"flag"];
    if(flag && [flag isEqualToString:@"2"]) {
        [dict setValue:reportType forKey:@"reportType"];
        [dict setValue:isSubscribe forKey:@"isSubscribe"];
    }
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestUpdateReportInfoDidFinished:)];
    [acReq execute];
}

- (void)requestUpdateReportInfoDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:request];
    }
}

@end
