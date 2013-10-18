//
//  SettleService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SettleService.h"

@implementation SettleService

-(void)requestForSettleManagement{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/lastBalByTth"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000012" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(settleManagementRequestDidFinished:)];
    [acReq execute];
}

-(void)settleManagementRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processSettleMgtData:)]) {
        [target performSelector:@selector(processSettleMgtData:) withObject:body];
    }
}

-(void)requestForSettleQuery:(NSString *)startDateSTR endDate:(NSString *)endDateSTR resendFlag:(NSString *)resendFlag{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/balance/queryBalanceList"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:startDateSTR forKey:@"beginDate"];
    [dict setValue:endDateSTR forKey:@"endDate"];
    [dict setValue:resendFlag forKey:@"resend"];
    [dict setValue:DEFAULT_REQUEST_NUM forKey:@"pcnt"];
    [dict setValue:@"00000006" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(settleQueryRequestDidFinished:)];
    [acReq execute];
}

-(void)settleQueryRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processSettleQueryData:)]) {
        [target performSelector:@selector(processSettleQueryData:) withObject:body];
    }
}

@end
