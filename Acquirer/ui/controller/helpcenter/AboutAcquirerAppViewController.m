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
    phoneTitleLabel.frame = CGRectMake(0, 0, 100, 20);
    phoneTitleLabel.textAlignment = NSTextAlignmentRight;
    phoneTitleLabel.font = [UIFont systemFontOfSize:16];
    phoneTitleLabel.text = [NSString stringWithFormat:@"客服电话："];
    phoneTitleLabel.backgroundColor = [UIColor clearColor];
    phoneTitleLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds)-100, CGRectGetMidY(self.contentView.bounds));
    [aboutImageView addSubview:phoneTitleLabel];
    
    UILabel *phoneTextLabel = [[[UILabel alloc] init] autorelease];
    phoneTextLabel.frame = CGRectMake(0, 0, 200, 20);
    phoneTextLabel.textAlignment = NSTextAlignmentRight;
    phoneTextLabel.textColor = [Helper amountRedColor];
    phoneTextLabel.backgroundColor = [UIColor clearColor];
    phoneTextLabel.font = [UIFont boldSystemFontOfSize:20];
    phoneTextLabel.text = [NSString stringWithFormat:@"021-33323999-5183"];
    phoneTextLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds)+30, CGRectGetMidY(self.contentView.bounds));
    [aboutImageView addSubview:phoneTextLabel];
    
    
}

@end
