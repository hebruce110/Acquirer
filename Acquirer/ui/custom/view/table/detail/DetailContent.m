//
//  DetailContent.m
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "DetailContent.h"

@implementation DetailContent

@synthesize orderIdSTR;
@synthesize bankCardSTR, tradeTimeSTR;
@synthesize tradeAmtSTR, tradeTypeSTR, tradeStatSTR;

-(void)dealloc{
    [orderIdSTR release];
    [bankCardSTR release];
    [tradeTimeSTR release];
    [tradeAmtSTR release];
    [tradeTypeSTR release];
    [tradeStatSTR release];
    [super dealloc];
}

@end
