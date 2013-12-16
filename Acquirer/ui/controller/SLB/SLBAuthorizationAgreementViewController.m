//
//  SLBAuthorizationAgreementViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeHomeViewController.h"
#import "SLBAuthorizationAgreementViewController.h"
#import "SLBServeAgreementViewController.h"
#import "SLBUserNotiDocViewController.h"
#import "SLBCheckBox.h"
#import "SLBHelper.h"

@interface SLBAuthorizationAgreementViewController ()

@property (retain, nonatomic) UIImageView *bgImgView;
@property (retain, nonatomic) SLBCheckBox *agreeBox;
@property (retain, nonatomic) UIButton *agreementButton;
@property (retain, nonatomic) UIButton *confirmButton;

@end

@implementation SLBAuthorizationAgreementViewController

- (void)dealloc
{
    self.bgImgView = nil;
    self.agreeBox = nil;
    self.agreementButton = nil;
    self.confirmButton = nil;
    
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
        _agreeBox = nil;
        _agreementButton = nil;
        _confirmButton = nil;
        
        _isBackToMenuControl = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"生利宝"];
    
    CGFloat space = 18.0f;
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 246.0f)];
    [_bgImgView setImage:[UIImage imageNamed:@"shenglibao-bg"]];
    [self.contentView addSubview:_bgImgView];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 57.0f)];
    _confirmButton.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMaxY(_bgImgView.frame) + 22.0f + space * 2.0f + _confirmButton.bounds.size.height * 0.5f);
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    _confirmButton.layer.cornerRadius = 5.0f;
    _confirmButton.clipsToBounds = YES;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_confirmButton];
    
    _agreeBox = [[SLBCheckBox alloc] initWithFrame:CGRectMake(_confirmButton.frame.origin.x, CGRectGetMaxY(_bgImgView.frame) + space, 60.0f, 22.0f)];
    [_agreeBox addTarget:self action:@selector(agreeBoxTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBox setTitle:@"同意" font:[UIFont systemFontOfSize:16]];
    [_agreeBox setImage:[UIImage imageNamed:@"checkbox_nor"] forState:SLBCheckBoxStateDeSelected];
    [_agreeBox setImage:[UIImage imageNamed:@"checkbox_sle"] forState:SLBCheckBoxStateSelected];
    _agreeBox.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_agreeBox];
    
    _agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agreeBox.frame), _agreeBox.frame.origin.y, CGRectGetWidth(self.contentView.bounds) * 0.5f, _agreeBox.bounds.size.height)];
    [_agreementButton setTitleColor:[UIColor slbBlueColor] forState:UIControlStateNormal];
    [_agreementButton setTitle:@"《生利宝授权协议》" forState:UIControlStateNormal];
    [_agreementButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_agreementButton addTarget:self action:@selector(agreementButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_agreementButton];
    
    _agreeBox.isSelected = YES;
}

- (void)backToPreviousView:(id)sender
{
    if(!_isBackToMenuControl) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    TradeHomeViewController *tradeHomeViewCtrl = nil;
    for(id ctrl in self.navigationController.viewControllers) {
        if([ctrl isKindOfClass:[TradeHomeViewController class]]) {
            tradeHomeViewCtrl = ctrl;
            break;
        }
    }
    
    if(tradeHomeViewCtrl) {
        [self.navigationController popToViewController:tradeHomeViewCtrl animated:YES];
    }
    else {
        tradeHomeViewCtrl = [[TradeHomeViewController alloc] init];
        NSMutableArray *mtlViewCtrls = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mtlViewCtrls insertObject:tradeHomeViewCtrl atIndex:0];
        [tradeHomeViewCtrl release];
        [self.navigationController setViewControllers:mtlViewCtrls animated:NO];
        [self.navigationController popToViewController:tradeHomeViewCtrl animated:YES];
    }
}

- (void)agreeBoxTouched:(id)sender
{
    _confirmButton.enabled = _agreeBox.isSelected;
}

- (void)agreementButtonTouched:(id)sender
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000033"];
    
    SLBUserNotiDocViewController *userNotiViewCtrl = [[SLBUserNotiDocViewController alloc] init];
    userNotiViewCtrl.agreementType = SLBUserNotiTypeAuthorization;
    [self.navigationController pushViewController:userNotiViewCtrl animated:YES];
    [userNotiViewCtrl setNavigationTitle:@"生利宝授权协议"];
    [userNotiViewCtrl release];
}

- (void)confirmButtonTouched:(id)sender
{
    SLBServeAgreementViewController *userServeAgreeViewCtrl = [[SLBServeAgreementViewController alloc] init];
    [self.navigationController pushViewController:userServeAgreeViewCtrl animated:YES];
    [userServeAgreeViewCtrl release];
}

@end
