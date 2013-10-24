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
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

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
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGFloat widthOffset = 30;
    UILabel *avlBalTitleLabel = [[UILabel alloc] init];
    avlBalTitleLabel.frame = CGRectMake(widthOffset, 20, 100, 20);
    avlBalTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    avlBalTitleLabel.backgroundColor = [UIColor clearColor];
    avlBalTitleLabel.textAlignment = NSTextAlignmentLeft;
    avlBalTitleLabel.text = @"可取金额：";
    [self.contentView addSubview:avlBalTitleLabel];
    [avlBalTitleLabel release];
    
    //金额
    CGFloat textWidth = 180;
    UILabel *avlBalTextLabel = [[UILabel alloc] init];
    avlBalTextLabel.frame = CGRectMake(contentWidth-widthOffset-10-textWidth, 20, textWidth, 20);
    avlBalTextLabel.font = [UIFont boldSystemFontOfSize:18];
    avlBalTextLabel.backgroundColor = [UIColor clearColor];
    avlBalTextLabel.textColor = [UIColor redColor];
    avlBalTextLabel.textAlignment = NSTextAlignmentRight;
    avlBalTextLabel.text = [Helper processAmtDisplay:ec.avlBalSTR];
    [self.contentView addSubview:avlBalTextLabel];
    [avlBalTextLabel release];
    
    //单位
    UILabel *avlUnitLabel = [[UILabel alloc] init];
    avlUnitLabel.frame = CGRectMake(contentWidth-widthOffset-10, 20, 10, 20);
    avlUnitLabel.font = [UIFont boldSystemFontOfSize:16];
    avlUnitLabel.backgroundColor = [UIColor clearColor];
    avlUnitLabel.textAlignment = NSTextAlignmentLeft;
    avlUnitLabel.text = @"元";
    [self.contentView addSubview:avlUnitLabel];
    [avlUnitLabel release];
    
    
}

@end













