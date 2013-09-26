//
//  DetailService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DetailService.h"

@implementation DetailService

-(void)dealloc{
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/*
    detailType：今日｜历史
    resendFlag：分页上次接收的resend值
    reqflag：请求的类型：全部｜成功｜失败
    cardNoSTR：银行卡号
    amtSTR：交易金额
 */
//默认请求条数
#define DEFAULT_REQUEST_NUM @"30"
-(void)requestForTradeDetail:(DetailType) detailType withResendFlag:(NSString *)resendFlag withReqFlag:(ReqFlag)reqflag
                  withCardNo:(NSString *) cardNoSTR withAmt:(NSString *) amtSTR
                    fromDate:(NSString *) fdate toDate:(NSString *) tdate{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/ord/queryOrdList"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:cardNoSTR forKey:@"cardNo"];
    [dict setValue:amtSTR forKey:@"amt"];
    [dict setValue:fdate forKey:@"beginDate"];
    [dict setValue:tdate forKey:@"endDate"];
    [dict setValue:[NSString stringWithFormat:@"%d", reqflag] forKey:@"flag"];
    [dict setValue:resendFlag forKey:@"resend"];
    [dict setValue:DEFAULT_REQUEST_NUM forKey:@"pcnt"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    
    if (detailType == Detail_Type_Today) {
        [dict setValue:@"1" forKey:@"reportFlag"];
        [dict setValue:@"00000011" forKey:@"functionId"];
    }else if (detailType == Detail_Type_History){
        [dict setValue:@"0" forKey:@"reportFlag"];
        [dict setValue:@"00000015" forKey:@"functionId"];
    }else{}
    
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(tradyDetailRequestDidFinished:)];
    [acReq execute];
}

-(void)tradyDetailRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processDetailData:)]) {
        [target performSelector:@selector(processDetailData:) withObject:body];
    }
}

-(void)requestForTradeDetailInfo:(NSString *)orderId{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/ord/queryOrdById"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:orderId forKey:@"ordId"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:@"00000004" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(tradyDetailInfoRequestDidFinished:)];
    [acReq execute];
}

-(void)tradyDetailInfoRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *body = (NSDictionary *)req.responseAsJson;
    
    if (target && [target respondsToSelector:@selector(processDetailData:)]) {
        [target performSelector:@selector(processDetailData:) withObject:body];
    }
}

@end


























