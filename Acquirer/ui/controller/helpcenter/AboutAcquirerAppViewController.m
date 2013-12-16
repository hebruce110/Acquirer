//
//  AboutAcquirerAppViewController.m
//  Acquirer
//
//  Created by peer on 11/5/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "AboutAcquirerAppViewController.h"

@implementation AboutAcquirerAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"关于软件"];
    
    UIImage *aboutImg = IS_IPHONE5 ? [UIImage imageNamed:@"aboutus-568h@2x.png"]:[UIImage imageNamed:@"aboutus.png"];
    
    UIImageView *aboutImageView = [[UIImageView alloc] initWithImage:aboutImg];
    aboutImageView.frame = self.contentView.bounds;
    [self.contentView addSubview:aboutImageView];
    [aboutImageView release];
    
    UILabel *versionLabel = [[[UILabel alloc] init] autorelease];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.frame = CGRectMake(0, 0, 200, 20);
    versionLabel.font = [UIFont systemFontOfSize:16];
    versionLabel.text = [NSString stringWithFormat:@"iPhone 客户端 %@", [Acquirer bundleVersion]];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)-60);
    [aboutImageView addSubview:versionLabel];
    
    
    UILabel *phoneTitleLabel = [[[UILabel alloc] init] autorelease];
    phoneTitleLabel.frame = CGRectMake(HORIZONTAL_PADDING, 0, 130, 20);
    phoneTitleLabel.center = CGPointMake(phoneTitleLabel.center.x, CGRectGetMidY(self.contentView.bounds));
    phoneTitleLabel.textAlignment = NSTextAlignmentRight;
    phoneTitleLabel.font = [UIFont systemFontOfSize:16];
    phoneTitleLabel.text = [NSString stringWithFormat:@"客服电话："];
    phoneTitleLabel.backgroundColor = [UIColor clearColor];
    [aboutImageView addSubview:phoneTitleLabel];
    
    UILabel *phoneTextLabel = [[[UILabel alloc] init] autorelease];
    phoneTextLabel.frame = CGRectMake(CGRectGetMaxX(phoneTitleLabel.frame), 0, CGRectGetWidth(self.contentView.bounds) - CGRectGetWidth(phoneTitleLabel.frame) - HORIZONTAL_PADDING * 2.0f, CGRectGetHeight(phoneTitleLabel.frame));
    phoneTextLabel.center = CGPointMake(phoneTextLabel.center.x, phoneTitleLabel.center.y);
    phoneTextLabel.textAlignment = NSTextAlignmentLeft;
    phoneTextLabel.textColor = [Helper amountRedColor];
    phoneTextLabel.backgroundColor = [UIColor clearColor];
    phoneTextLabel.font = [UIFont boldSystemFontOfSize:20];
    phoneTextLabel.text = [NSString stringWithFormat:@"400-820-2819"];
    [aboutImageView addSubview:phoneTextLabel];
}

@end
