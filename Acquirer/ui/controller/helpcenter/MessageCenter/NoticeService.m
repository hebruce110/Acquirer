//
//  NoticeService.m
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "NoticeService.h"

@implementation NoticeService

//-----------------------------------
//公告、通知查询
- (void)requestNoticeListByResend:(NSString *)resend flag:(MessageFlag)flag reportFlag:(messageReportFlag)reportFlag Taget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/notice/queryNotices"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    
    [dict setValue:resend forKey:@"resend"];
    [dict setValue:DEFAULT_REQUEST_NUM forKey:@"pcnt"];
    [dict setValue:[NSString stringWithFormat:@"%u", flag] forKey:@"flag"];
    [dict setValue:[NSString stringWithFormat:@"%u", reportFlag] forKey:@"reportFlag"];
    
    if(reportFlag == messageReportNotice)
    {
        [dict setValue:@"00000008" forKey:@"functionId"];
    }
    else if(reportFlag == messageReportNotification)
    {
        [dict setValue:@"00000009" forKey:@"functionId"];
    }
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestNoticeListDidFinished:)];
    [acReq execute];
}

- (void)requestNoticeListDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

//-----------------------------------
//公告、通知详情查询
- (void)requestNoticeDetailByFlag:(MessageFlag)flag noticeId:(NSString *)noticeId Taget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/notice/queryNoticeInfo"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:[NSString stringWithFormat:@"%u", flag] forKey:@"flag"];
    if(noticeId)
    {
        [dict setValue:noticeId forKey:@"noticeId"];
    }
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestNoticeDetailDidFinished:)];
    [acReq execute];
}

- (void)requestNoticeDetailDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

//-----------------------------------
//留言信息查询
- (void)requestLeaveMessageByResend:(NSString *)resend Taget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/notice/queryMessages"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:resend forKey:@"resend"];
    [dict setValue:DEFAULT_REQUEST_NUM forKey:@"pcnt"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestLeaveMessageDidFinished:)];
    [acReq execute];
}

- (void)requestLeaveMessageDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

//-----------------------------------
//留言信息详情
- (void)requestLeaveMessageDetailByMsgId:(NSString *)msgId Taget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/notice/queryMsgInfo"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    if(msgId)
    {
        [dict setValue:msgId forKey:@"msgId"];
    }
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestLeaveMessageDetailDidFinished:)];
    [acReq execute];
}

- (void)requestLeaveMessageDetailDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

//-----------------------------------
//留言信息新增
- (void)requestAddLeaveMessageByTitle:(NSString *)title content:(NSString *)content Taget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"添加留言中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/notice/addMessage"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:title forKey:@"title"];
    [dict setValue:content forKey:@"content"];
    
    NSLog(@"### request dict:%@", dict);
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(requestAddLeaveMessageDidFinished:)];
    [acReq execute];
}

- (void)requestAddLeaveMessageDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

@end
