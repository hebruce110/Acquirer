//
//  TradeEncashViewController.m
//  Acquirer
//
//  即时取现
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeEncashViewController.h"

@implementation EncashModel

@synthesize avlBalSTR, cashAmtSTR, miniAmtSTR;
@synthesize bankNameSTR, acctIdSTR, agentNameSTR;

-(void)dealloc{
    [avlBalSTR release];
    [cashAmtSTR release];
    [miniAmtSTR release];
    [bankNameSTR release];
    [acctIdSTR release];
    [agentNameSTR release];
    
    [super dealloc];
}

@end

@implementation TradeEncashViewController

@synthesize ec;

-(void)dealloc{
    [ec release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"即时取现"];
    
}

@end
