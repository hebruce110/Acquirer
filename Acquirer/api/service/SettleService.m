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
    [dict setValue:@"" forKey:@"checkValue"];
    [dict setValue:[self oprateTime] forKey:@"operTime"];
    [dict setValue:[Acquirer UID] forKey:@"uid"];
    [dict setValue:[Acquirer bundleVersion] forKey:@"version"];
    [dict setValue:@"00000012" forKey:@"functionId"];
    [dict setValue:[[DeviceIntrospection sharedInstance] IPAddress] forKey:@"ip"];
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest getRequestWithPath:url andQuery:dict];
    [acReq onRespondTarget:self selector:@selector(settleManagementRequestDidFinished:)];
    [acReq execute];
}

-(void)settleManagementRequestDidFinished:(AcquirerCPRequest *)req{
    
}

@end
