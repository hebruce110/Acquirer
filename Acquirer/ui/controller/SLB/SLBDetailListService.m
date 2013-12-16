//
//  SLBDetailListService.m
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBDetailListService.h"
#import "ASIHTTPRequest.h"

@implementation SLBDetailListService

//明细查询
- (void)requestForResend:(NSString *)resend target:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"查询中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/slb/queryDetail"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000026" forKey:@"functionId"];
    [dict setValue:resend forKey:@"resend"];
    [dict setValue:DEFAULT_REQUEST_NUM forKey:@"pcnt"];
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(detailListDidFinished:)];
    [acReq execute];
}

- (void)detailListDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:request];
    }
}

@end
