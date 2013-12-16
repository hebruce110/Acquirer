//
//  SLBChangeAmountService.m
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBChangeAmountService.h"

@implementation SLBChangeAmountService

//转入、转出
- (void)requestForServeNum:(NSString *)sernum changeType:(SLBChangeType)type changeAmt:(NSString *)amt target:(id)tg action:(SEL)action
{
    target = tg;
    selector = action;
    
    Acquirer *ac = [Acquirer sharedInstance];
    NSString* url = [NSString stringWithFormat:@"/slb/change"];
    NSString *amountStr = amt;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    switch(type)
    {
        case SLBChangeIn:
        {
            [ac showUIPromptMessage:@"存入中..." animated:YES];
            [dict setValue:@"00000028" forKey:@"functionId"];
            [dict setValue:@"I" forKey:@"changeType"];
        }break;
            
        case SLBChangeOut:
        {
            [ac showUIPromptMessage:@"转出中..." animated:YES];
            [dict setValue:@"00000030" forKey:@"functionId"];
            [dict setValue:@"O" forKey:@"changeType"];
        }break;
            
        default:
            break;
    }
    
    [dict setValue:ac.currentUser.instSTR forKey:@"instId"];
    [dict setValue:ac.currentUser.opratorSTR forKey:@"operId"];
    [dict setValue:amountStr forKey:@"changeAmt"];
    [dict setValue:sernum forKey:@"sernum"];
    
    AddOptionalReqInfomation(dict);
    
    AcquirerCPRequest *acReq = [AcquirerCPRequest postRequestWithPath:url andBody:dict];
    [dict release];
    
    [acReq onRespondTarget:self selector:@selector(changeAmountDidFinished:)];
    [acReq execute];
}

- (void)changeAmountDidFinished:(AcquirerCPRequest *)request
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if(target && [target respondsToSelector:selector])
    {
        [target performSelector:selector withObject:request];
    }
}

@end
