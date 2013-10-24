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
    avlBalTextLabel.frame = CGRectMake(contentWidth-widthOffset-25-textWidth, 20, textWidth, 20);
    avlBalTextLabel.font = [UIFont boldSystemFontOfSize:20];
    avlBalTextLabel.backgroundColor = [UIColor clearColor];
    avlBalTextLabel.textColor = [UIColor redColor];
    avlBalTextLabel.textAlignment = NSTextAlignmentRight;
    avlBalTextLabel.text = [Helper processAmtDisplay:ec.avlBalSTR];
    [self.contentView addSubview:avlBalTextLabel];
    [avlBalTextLabel release];
    
    //单位
    UILabel *avlUnitLabel = [[UILabel alloc] init];
    avlUnitLabel.frame = CGRectMake(contentWidth-widthOffset-20, 20, 20, 20);
    avlUnitLabel.font = [UIFont boldSystemFontOfSize:16];
    avlUnitLabel.backgroundColor = [UIColor clearColor];
    avlUnitLabel.textAlignment = NSTextAlignmentLeft;
    avlUnitLabel.text = @"元";
    [self.contentView addSubview:avlUnitLabel];
    [avlUnitLabel release];
    
    UILabel *cashAmtTitleLabel = [[UILabel alloc] init];
    cashAmtTitleLabel.frame = CGRectMake(widthOffset, 50, 120, 20);
    cashAmtTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    cashAmtTitleLabel.backgroundColor = [UIColor clearColor];
    cashAmtTitleLabel.textAlignment = NSTextAlignmentLeft;
    cashAmtTitleLabel.text = @"当日取现额度：";
    [self.contentView addSubview:cashAmtTitleLabel];
    [cashAmtTitleLabel release];
    
    UILabel *cashAmtTextLabel = [[UILabel alloc] init];
    cashAmtTextLabel.frame = CGRectMake(contentWidth-widthOffset-25-textWidth, 50, textWidth, 20);
    cashAmtTextLabel.font = [UIFont boldSystemFontOfSize:20];
    cashAmtTextLabel.backgroundColor = [UIColor clearColor];
    cashAmtTextLabel.textColor = [UIColor redColor];
    cashAmtTextLabel.textAlignment = NSTextAlignmentRight;
    cashAmtTextLabel.text = [Helper processAmtDisplay:ec.cashAmtSTR];
    [self.contentView addSubview:cashAmtTextLabel];
    [cashAmtTextLabel release];
    
    //单位
    UILabel *cashUnitLabel = [[UILabel alloc] init];
    cashUnitLabel.frame = CGRectMake(contentWidth-widthOffset-20, 50, 20, 20);
    cashUnitLabel.font = [UIFont boldSystemFontOfSize:16];
    cashUnitLabel.backgroundColor = [UIColor clearColor];
    cashUnitLabel.textAlignment = NSTextAlignmentLeft;
    cashUnitLabel.text = @"元";
    [self.contentView addSubview:cashUnitLabel];
    [cashUnitLabel release];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(cashAmtTitleLabel.frame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    
    
}

@end













