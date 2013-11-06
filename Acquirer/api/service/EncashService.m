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
#import "TradeEncashConfirmViewController.h"

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

//请求即时取现
-(void)requestForEncashImmediately:(NSString *)amtSTR{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"请求中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/queryFeeAmt"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:amtSTR forKey:@"cashAmt"];
    [dict setValue:@"00000021" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(encashImmediatelyRequestDidFinished:)];
    [acReq execute];
}

-(void)encashImmediatelyRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *dict = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processEncashImmediatelyData:)]) {
        [target performSelector:@selector(processEncashImmediatelyData:) withObject:dict];
    }
}

//即时取现确认
-(void)requestForEncashConfirm:(NSString *)amtSTR{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"请求中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/imBalConfirm"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:amtSTR forKey:@"cashAmt"];
    [dict setValue:@"00000022" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [acReq onRespondTarget:self selector:@selector(encashConfirmRequestDidFinished:)];
    [acReq execute];
}

-(void)encashConfirmRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    //取现成功
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000023"];
    
    if (target && [target respondsToSelector:@selector(processEncashRes:)]) {
        [(TradeEncashConfirmViewController *)target processEncashRes:EncashSuccess];
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
    
    if (target && [target isKindOfClass:[TradeEncashConfirmViewController class]]) {
        if (NotNilAndEqualsTo(dict, MTP_RESPONSE_CODE, @"02330")) {
            [(TradeEncashConfirmViewController *)target processEncashRes:EncashPending];
        }else{
            [(TradeEncashConfirmViewController *)target processEncashRes:EncashFailure];
        }
    }
}



@end
