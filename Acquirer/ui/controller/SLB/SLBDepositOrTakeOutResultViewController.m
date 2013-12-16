//
//  SLBDepositOrTakeOutResultViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBDepositOrTakeOutResultViewController.h"
#import "SLBMenuViewController.h"
#import "SLBAttributedView.h"
#import "SLBHelper.h"

@interface SLBDepositOrTakeOutResultViewController ()

@property (retain, nonatomic) UIImageView *iconImageView;
@property (retain, nonatomic) UILabel *detailTitleLabel;
@property (retain, nonatomic) SLBAttributedView *resultInfoView;
@property (retain, nonatomic) UIButton *backToMenuButton;

@end

@implementation SLBDepositOrTakeOutResultViewController

- (void)dealloc
{
    self.iconImageView = nil;
    self.detailTitleLabel = nil;
    self.resultInfoView = nil;
    self.backToMenuButton = nil;
    
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
        
        _resultType = SLBResultDesposit;
        _amountChanged = 0;
        _iconImageView = nil;
        _detailTitleLabel = nil;
        _resultInfoView = nil;
        _backToMenuButton = nil;
        
        _isBackToMenuControl = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hideBackButton];
    
    [self addViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableAttributedString *attributedStr = nil;
    switch(_resultType) {
        case SLBResultDesposit: {
            _detailTitleLabel.text = @"存入成功!";
            
            NSString *hdStr = @"您成功存入生利宝";
            NSString *amountStr = [NSString micrometerSymbolAmount:_amountChanged];
            NSString *str = [NSString stringWithFormat:@"%@%@元", hdStr, amountStr];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(MAX(hdStr.length, 0), amountStr.length);
            
            [attributedStr beginEditing];
            [attributedStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:redRange];
            [attributedStr endEditing];
        }break;
            
        case SLBResultTakeOut: {
            _detailTitleLabel.text = @"转出成功!";
            
            NSString *hdStr = @"您成功转出生利宝";
            NSString *amountStr = [NSString micrometerSymbolAmount:_amountChanged];
            NSString *str = [NSString stringWithFormat:@"%@%@元", hdStr, amountStr];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
            NSRange redRange = NSMakeRange(MAX(hdStr.length, 0), amountStr.length);
            
            [attributedStr beginEditing];
            [attributedStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:redRange];
            [attributedStr endEditing];
        }break;
            
        default:
            break;
    }
    
    CTParagraphStyleSetting alignmentSetting;
    CTTextAlignment alg = kCTTextAlignmentCenter;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.value = &alg;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);

    CTParagraphStyleSetting settings[] = {alignmentSetting};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);

    CTFontRef ctFont16 = [UIFont systemFontOfSize:16].ctFont;
    [attributedStr beginEditing];
    [attributedStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont16 range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    [attributedStr endEditing];
    
    CFRelease(ctFont16);
    CFRelease(paragraphStyle);
    
    [_resultInfoView setAttributeString:attributedStr];
    [attributedStr release];
}

- (void)addViews
{
    CGSize ctSize = self.contentView.bounds.size;
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55.0f, 32.0f, 37.0f, 37.0f)];
    [_iconImageView setImage:[UIImage imageNamed:@"success"]];
    [self.contentView addSubview:_iconImageView];
    
    _detailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ctSize.width, 98.0f)];
    _detailTitleLabel.backgroundColor = [UIColor clearColor];
    _detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    _detailTitleLabel.font = [UIFont systemFontOfSize:32];
    [self.contentView addSubview:_detailTitleLabel];
    _iconImageView.center = CGPointMake(_iconImageView.center.x, _detailTitleLabel.center.y);
    
    UIImageView *breakImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_detailTitleLabel.frame), 300.0f, 1.0f)];
    breakImageView.center = CGPointMake(CGRectGetMidX(self.contentView.frame), breakImageView.center.y);
    [breakImageView setImage:[UIImage imageNamed:@"dashed"]];
    [self.contentView addSubview:breakImageView];
    [breakImageView release];
    
    _resultInfoView = [[SLBAttributedView alloc] initWithFrame:CGRectMake(0, 120.0f, ctSize.width, 25.0f)];
    _resultInfoView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_resultInfoView];
    
    _backToMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 162.0f, 145.0f, 38.0f)];
    _backToMenuButton.center = CGPointMake(CGRectGetMidX(self.contentView.frame), _backToMenuButton.center.y);
    [_backToMenuButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateNormal];
    [_backToMenuButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateHighlighted];
    [_backToMenuButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateSelected];
    _backToMenuButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _backToMenuButton.layer.cornerRadius = 4.0f;
    _backToMenuButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _backToMenuButton.layer.borderWidth = 1.0f;
    _backToMenuButton.clipsToBounds = YES;
    [_backToMenuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backToMenuButton setTitle:@"返回生利宝" forState:UIControlStateNormal];
    [_backToMenuButton addTarget:self action:@selector(backToMenuButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_backToMenuButton];
}

- (void)backToMenuButtonTouched:(id)sender
{
    if(_resultType == SLBResultDesposit) {
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000031"];
    }
    else if(_resultType == SLBResultTakeOut) {
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000032"];
    }
    
    if(!_isBackToMenuControl) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    SLBMenuViewController *slbMenuViewCtrl = nil;
    for(id ctrl in self.navigationController.viewControllers) {
        if([ctrl isKindOfClass:[SLBMenuViewController class]]) {
            slbMenuViewCtrl = ctrl;
            slbMenuViewCtrl.isNeedfresh = YES;
            break;
        }
    }
    
    if(slbMenuViewCtrl) {
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
    }
    else {
        slbMenuViewCtrl = [[SLBMenuViewController alloc] init];
        slbMenuViewCtrl.isNeedfresh = YES;
        
        NSMutableArray *mtlViewCtrls = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mtlViewCtrls insertObject:slbMenuViewCtrl atIndex:mtlViewCtrls.count - 2];
        [slbMenuViewCtrl release];
        [self.navigationController setViewControllers:mtlViewCtrls animated:NO];
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
    }
}

@end
