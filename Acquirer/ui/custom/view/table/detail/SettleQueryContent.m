//
//  SettleQueryContent.m
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SettleQueryContent.h"

@implementation SettleQueryContent

@synthesize accountIdSTR, balAmtSTR, balDateSTR;
@synthesize balSeqIdSTR, balStatSTR, cashChannelSTR;

-(void)dealloc{
    [accountIdSTR release];
    [balAmtSTR release];
    [balDateSTR release];
    [balSeqIdSTR release];
    [balStatSTR release];
    [cashChannelSTR release];
    
    [super dealloc];
}

@end
