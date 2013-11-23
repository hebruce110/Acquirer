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
- (void)requestForQueryTaget:(id)tg action:(SEL)action
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
    
    NSArray *keys = [NSArray arrayWithObjects:@"acctStat", @"settleFund", @"totalAsset", @"curProfit", @"totalProfit", @"minIn", @"maxIn", @"minOut", @"maxOut", @"prodiderName", @"fullName", @"certType", @"certNo", @"cardNo", @"mobile", nil];
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    SLBUser *slbUsr = [SLBService sharedService].slbUser;
    for(NSString *key in keys)
    {
        id value = [body objectForKey:key];
        if(value)
        {
            [slbUsr setObject:value forKey:key];
        }
    }
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

@end
