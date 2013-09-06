//
//  ActivateViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ActivateViewController.h"

@interface ActivateViewController ()

@end

@implementation ActivateViewController

@synthesize mobileSTR;

-(void)dealloc{
    [mobileSTR release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGRect hintFrame = CGRectMake(10, 10, 300, 60);
    UILabel *hintMsgLabel = [[[UILabel alloc] initWithFrame:hintFrame] autorelease];
    hintMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    hintMsgLabel.font = [UIFont systemFontOfSize:15];
    hintMsgLabel.text = @"账号未激活,请输入以下信息,验证通过后可正常使用";
    hintMsgLabel.backgroundColor = [UIColor clearColor];
    hintMsgLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:hintMsgLabel];
    
    CGRect mobileFrame = CGRectMake(20, 60, 120, 35);
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:mobileFrame];
    mobileLabel.font = [UIFont systemFontOfSize:15];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    mobileLabel.text = [NSString stringWithFormat:@"手机号:%@", mobileSTR];
    [self.contentView addSubview:mobileLabel];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











