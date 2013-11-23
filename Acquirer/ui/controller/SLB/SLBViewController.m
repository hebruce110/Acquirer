//
//  SLBViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBViewController.h"
#import "SLBAuthorizationAgreementViewController.h"
#import "SLBMenuViewController.h"
#import "SLBService.h"
#import "SLBHelper.h"

@interface SLBViewController ()

@property (retain, nonatomic) UIImageView *bgImgView;
@property (retain, nonatomic) UIButton *employButton;

@end

@implementation SLBViewController

- (void)dealloc
{
    [_bgImgView release];
    _bgImgView = nil;
    
    [_employButton release];
    _employButton = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
        
        _bgImgView = nil;
        _employButton = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"生利宝"];
    
    _bgImgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _employButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 57.0f)];
    
    _employButton.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), self.contentView.bounds.size.height - _employButton.bounds.size.height);
    
    [_bgImgView setImage:[UIImage imageNamed:@"aboutshenglibao-bg"]];
    [_employButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_employButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_employButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    
    _employButton.layer.cornerRadius = 5.0f;
    _employButton.clipsToBounds = YES;
    _employButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_employButton setTitle:@"立即体验" forState:UIControlStateNormal];
    
    [_employButton addTarget:self action:@selector(employButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_bgImgView];
    [self.contentView addSubview:_employButton];
}

- (void)employButtonTouched:(id)sender
{
    [self updateSLBUserInfo];
}

- (void)updateSLBUserInfo
{
    [[SLBService sharedService].querySer requestForQueryTaget:self action:@selector(updateSLBUserInfoDidFinished)];
}

- (void)updateSLBUserInfoDidFinished
{
    BOOL acctStatC = [SLBHelper blFromSLBAgentSlbFlag:[[SLBService sharedService].slbUser safeObjectForKey:@"acctStat"] equalYESString:@"C"];
    if(acctStatC)
    {
        SLBAuthorizationAgreementViewController *authorizationViewCtrl = [[SLBAuthorizationAgreementViewController alloc] init];
        [self.navigationController pushViewController:authorizationViewCtrl animated:YES];
        [authorizationViewCtrl release];
    }
}

@end
