//
//  SLBOpenService.m
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBOpenService.h"
#import "ASIHTTPRequest.h"

@implementation SLBOpenService

- (void)requestForOpenTarget:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    [ac showUIPromptMessage:@"开户中..." animated:YES];
    
    NSString* url = [NSString stringWithFormat:@"/slb/open"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:@"00000025" forKey:@"functionId"];
    
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(openDidFinished:)];
    [acReq execute];
}

- (void)openDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:request];
    }
}

@end
