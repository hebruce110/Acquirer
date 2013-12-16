//
//  SLBQueryService.m
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBQueryService.h"
#import "SLBService.h"

@implementation SLBQueryService

//查询
- (void)requestForQueryTarget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/slb/queryInfo"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000024" forKey:@"functionId"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(queryDidFinished:)];
    [acReq execute];
}

- (void)queryDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"acctStat",       /*账户状态*/
                     @"settleFund",     /*当前待结算资金*/
                     @"totalAsset",     /*生利宝总金额*/
                     @"curProfit",      /*当日收益*/
                     @"totalProfit",    /*历史累计收益*/
                     @"minIn",          /*最低转入金额*/
                     @"maxIn",          /*最高转入金额*/
                     @"minOut",         /*最低转出金额*/
                     @"maxOut",         /*最高转出金额*/
                     @"prodiderName",   /*服务提供方*/
                     @"fullName",       /*姓名*/
                     @"certType",       /*证件类型*/
                     @"certNo",         /*证件号码*/
                     @"cardNo",         /*银行卡号*/
                     @"mobile",         /*手机号*/
                     nil];
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    
    //保存生利宝用户信息
    SLBUser *slbUsr = [SLBService sharedService].slbUser;
    for(NSString *key in keys) {
        id value = [body objectForKey:key];
        if(value) {
            [slbUsr setObject:value forKey:key];
        }
    }
    
    if(target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:request];
    }
}

@end
