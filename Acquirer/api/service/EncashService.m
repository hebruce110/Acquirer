//
//  EncashService.m
//  Acquirer
//
//  即时取现
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "EncashService.h"
#import "BaseViewController.h"

#import "TradeEncashProtocalViewController.h"
#import "TradeEncashViewController.h"

@implementation EncashService

-(void)requestForBalanceAuth{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/reqImBal"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000019" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(balanceAuthRequestDidFinished:)];
    [acReq execute];
}

-(void)balanceAuthRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *dict = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processEncashData:)]) {
        [target performSelector:@selector(processEncashData:) withObject:dict];
    }
}

-(void)requestForProtocalAgreement{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/agreementConfirm"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000020" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(protocalAgreementRequestDidFinished:)];
    [acReq execute];
}

-(void)protocalAgreementRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processProtocalEncashData:)]) {
        [target performSelector:@selector(processProtocalEncashData:) withObject:body];
    }
}

//处理非标准返回码
-(void) processMTPRespCode:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *dict = (NSDictionary *)req.responseAsJson;
    //协议未签订，跳转到签订协议页面
    if (NotNilAndEqualsTo(dict, MTP_RESPONSE_CODE, @"02327")) {
        if (target && [target respondsToSelector:@selector(jumpToViewController:)]) {
            [target performSelector:@selector(jumpToViewController:) withObject:TradeEncashProtocalViewController.class];
        }
    }
}

@end
