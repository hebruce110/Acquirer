//
//  MessageService.m
//  Acquirer
//
//  短信请求
//
//  Created by chinapnr on 13-9-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "MessageService.h"
#import "AcquirerCPRequest.h"
#import "ACUser.h"
#import "Acquirer.h"
#import "NSNotificationCenter+CP.h"

@implementation MessageService

//请求短信接口
-(void)requestForShortMessage{
    [[Acquirer sharedInstance] showUIPromptMessage:@"获取中..." animated:YES];
    
    ACUser *usr = [[Acquirer sharedInstance] currentUser];
    
    NSString* url = [NSString stringWithFormat:@"/user/sendMsgByLogin"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:usr.instSTR forKey:@"instId"];
    [dict setValue:usr.opratorSTR forKey:@"operId"];
    [dict setValue:[Helper md5_16:usr.passSTR] forKey:@"password"];
    [dict setValue:@"" forKey:@"checkValue"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(messageRequestDidFinished:)];
    [acReq execute];
}

//恢复重发短信状态
-(void)restoreMessageSend{
    if (target && [target respondsToSelector:@selector(restoreShortMessageState)]) {
        [target performSelector:@selector(restoreShortMessageState)];
    }
}

-(void)messageRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *) req.responseAsJson;
    
    if (NotNilAndEqualsTo(body, @"isSucc", @"1")) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"短消息校验码已经发送，请注意查收"
                                                                     notifyType:NOTIFICATION_TYPE_SUCCESS];
        //设置1分钟内禁用获取激活码按钮
        if (target && [target respondsToSelector:@selector(disableShortMessageForOneMinute)]) {
            [target performSelector:@selector(disableShortMessageForOneMinute)];
        }
    }else{
        [self restoreMessageSend];
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"短消发送失败,请稍后再试"
                                                                     notifyType:NOTIFICATION_TYPE_WARNING];
    }
}

@end





