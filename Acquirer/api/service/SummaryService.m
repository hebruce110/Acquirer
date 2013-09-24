//
//  SummaryService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SummaryService.h"

@implementation SummaryService

//刷卡汇总
-(void)requestForTradeSummay:(SummaryType) sumType withPnrDevId:(NSString *)devIdSTR
                    fromDate:(NSString *)fdate toDate:(NSString *)tdate{
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/ord/queryOrdBySum"];
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:devIdSTR forKey:@"pnrDevId"];
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:fdate forKey:@"beginDate"];
    [dict setValue:tdate forKey:@"endDate"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    if (sumType == Summary_Type_Today) {
        [dict setValue:@"1" forKey:@"reportFlag"];
        [dict setValue:@"00000010" forKey:@"functionId"];
    }else if (sumType == Summary_Type_History){
        [dict setValue:@"0" forKey:@"reportFlag"];
        [dict setValue:@"00000005" forKey:@"functionId"];
    }else{}
    
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(tradySummaryRequestDidFinished:)];
    [acReq execute];
}

-(void)tradySummaryRequestDidFinished:(AcquirerCPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSDictionary *dict = (NSDictionary *) req.responseAsJson;
    if (target && [target respondsToSelector:@selector(processSummaryData:)]) {
        [target performSelector:@selector(processSummaryData:) withObject:dict];
    }
}

@end






