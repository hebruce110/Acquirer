//
//  SLBTakeOutViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBMenuViewController.h"
#import "SLBTakeOutViewController.h"
#import "SLBDepositOrTakeOutResultViewController.h"
#import "SLBAttributedView.h"
#import "SLBService.h"
#import "SLBHelper.h"
#import "SafeObject.h"

@interface SLBTakeOutViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (retain, nonatomic) UILabel *totalHeaderLabel;
@property (retain, nonatomic) SLBAttributedView *totalAmountView;
@property (retain, nonatomic) UITextField *takeOutTextField;
@property (retain, nonatomic) SLBAttributedView *promptView;
@property (retain, nonatomic) UIImageView *breakImageView;
@property (retain, nonatomic) UIButton *confirmButton;

@property (assign, nonatomic) CGFloat minOut;
@property (assign, nonatomic) CGFloat maxOut;
@property (assign, nonatomic) CGFloat totalAsset;

@end

@implementation SLBTakeOutViewController

- (void)dealloc
{
    self.totalHeaderLabel = nil;
    self.totalAmountView = nil;
    self.takeOutTextField = nil;
    self.promptView = nil;
    self.breakImageView = nil;
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
        self.isNeedfresh = YES;
        
        _totalHeaderLabel = nil;
        _totalAmountView = nil;
        _takeOutTextField = nil;
        _promptView = nil;
        _breakImageView = nil;
        _confirmButton = nil;
        
        _minOut = 0;
        _maxOut = 0;
        _totalAsset = 0;
        _isBackToMenuControl = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"转出"];
    
    [self addViews];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
    tapGesture.delegate = self;
    [self.contentView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isNeedfresh) {
        self.isNeedfresh = NO;
        [self reloadData];
    }
}

- (void)reloadData
{
    SLBUser *usr = [SLBService sharedService].slbUser;
    
    _minOut = [[usr safeObjectForKey:@"minOut"] floatValue];
    _maxOut = [[usr safeObjectForKey:@"maxOut"] floatValue];
    _totalAsset= [[usr safeObjectForKey:@"totalAsset"] floatValue];
    
    CGSize ctSize = self.contentView.bounds.size;
    
    CTParagraphStyleSetting amountAlignmentSetting;
    CTTextAlignment amountAlg = kCTTextAlignmentRight;
    amountAlignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    amountAlignmentSetting.value = &amountAlg;
    amountAlignmentSetting.valueSize = sizeof(CTTextAlignment);
    CTParagraphStyleSetting amountSettings[] = {amountAlignmentSetting};
    CTParagraphStyleRef amountParagraphStyle = CTParagraphStyleCreate(amountSettings, 1);
    
    NSString *amountStr = [[NSString micrometerSymbolAmount:_totalAsset] stringByAppendingString:@"元"];
    NSMutableAttributedString *amountAttStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    
    CTFontRef ctFont18 = [UIFont systemFontOfSize:18].ctFont;
    CTFontRef ctFont10 = [UIFont systemFontOfSize:10].ctFont;
    
    [amountAttStr beginEditing];
    [amountAttStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont18 range:NSMakeRange(0, amountAttStr.length)];
    [amountAttStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:NSMakeRange(0, amountAttStr.length - 1)];
    [amountAttStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont10 range:NSMakeRange(amountAttStr.length - 1, 1)];
    [amountAttStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)amountParagraphStyle range:NSMakeRange(0, amountAttStr.length)];
    [amountAttStr endEditing];
    
    CFRelease(ctFont10);
    CFRelease(ctFont18);
    CFRelease(amountParagraphStyle);
    
    [_totalAmountView setAttributeString:amountAttStr];
    [amountAttStr release];
    
    CGFloat amountWidth = _totalHeaderLabel.bounds.size.width;
    CGFloat amountHeight = [NSAttributedString heightOfAttributedString:_totalAmountView.attributeString WidthWidth:amountWidth];
    _totalAmountView.frame = CGRectMake(0, 0, amountWidth - 100.0f, amountHeight);
    _totalAmountView.center = CGPointMake(ctSize.width - CGRectGetMinX(_totalHeaderLabel.frame) - CGRectGetMidX(_totalAmountView.bounds), _totalHeaderLabel.center.y);
    
    _takeOutTextField.placeholder = [NSString stringWithFormat:@"最多可取款金额%0.2f元", _totalAsset];
}

- (void)addViews
{
    CGSize ctSize = self.contentView.bounds.size;
    CGFloat toLeft = 20.0f;
    
    _totalHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(toLeft, 5.0f, ctSize.width - toLeft * 2.0f, DEFAULT_ROW_HEIGHT + 5.0f)];
    _totalHeaderLabel.backgroundColor = [UIColor clearColor];
    _totalHeaderLabel.textAlignment = NSTextAlignmentLeft;
    _totalHeaderLabel.font = [UIFont systemFontOfSize:16];
    _totalHeaderLabel.text = @"生利宝总金额：";
    [self.contentView addSubview:_totalHeaderLabel];
    
    _totalAmountView = [[SLBAttributedView alloc] initWithFrame:_totalHeaderLabel.bounds];
    _totalAmountView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_totalAmountView];
    
    CGFloat txToLeft = 9.0f;
    UIImageView *textfieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake(txToLeft, CGRectGetMaxY(_totalHeaderLabel.frame), ctSize.width - txToLeft * 2.0f, DEFAULT_ROW_HEIGHT)];
    [textfieldBgView setImage:[UIImage imageNamed:@"BUTT_whi_on"]];
    textfieldBgView.layer.cornerRadius = 10.0f;
    textfieldBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textfieldBgView.layer.borderWidth = 1.0f;
    textfieldBgView.clipsToBounds = YES;
    [self.contentView addSubview:textfieldBgView];
    [textfieldBgView release];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_totalHeaderLabel.frame), CGRectGetMinY(textfieldBgView.frame), 100.0f, CGRectGetHeight(textfieldBgView.frame))];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = _totalHeaderLabel.font;
    titleLabel.text = @"转出金额(元):";
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    _takeOutTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), CGRectGetWidth(textfieldBgView.frame) - CGRectGetMaxX(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
    _takeOutTextField.borderStyle = UITextBorderStyleNone;
    _takeOutTextField.font = titleLabel.font;
    _takeOutTextField.adjustsFontSizeToFitWidth = YES;
    _takeOutTextField.minimumFontSize = 10;
    _takeOutTextField.textAlignment = NSTextAlignmentRight;
    _takeOutTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _takeOutTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _takeOutTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _takeOutTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _takeOutTextField.delegate = self;
    [self.contentView addSubview:_takeOutTextField];
    
    CTParagraphStyleSetting notiAlignmentSetting;
    CTTextAlignment notiAlg = kCTTextAlignmentLeft;
    notiAlignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    notiAlignmentSetting.value = &notiAlg;
    notiAlignmentSetting.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting notiSpaceSetting;
    CGFloat space = 7.5f;
    notiSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    notiSpaceSetting.value = &space;
    notiSpaceSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting notiSettings[] = {notiAlignmentSetting, notiSpaceSetting};
    CTParagraphStyleRef notiParagraphStyle = CTParagraphStyleCreate(notiSettings, 2);
    CGFloat promptSpace = 15.0f;
    _promptView = [[SLBAttributedView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_totalHeaderLabel.frame), CGRectGetMaxY(textfieldBgView.frame) + promptSpace, CGRectGetWidth(textfieldBgView.frame) - CGRectGetMinX(_totalHeaderLabel.frame), 50.0f)];
    _promptView.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *mtlAttStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n资金会按照正常结算时间到您的银行帐户"];
    
    CTFontRef ctFont12 = [UIFont systemFontOfSize:12].ctFont;
    
    [mtlAttStr beginEditing];
    [mtlAttStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont12 range:NSMakeRange(0, mtlAttStr.length)];
    [mtlAttStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)notiParagraphStyle range:NSMakeRange(0, mtlAttStr.length)];
    [mtlAttStr endEditing];
    
    CFRelease(ctFont12);
    CFRelease(notiParagraphStyle);
    
    [_promptView setAttributeString:mtlAttStr];
    [mtlAttStr release];
    
    [self.contentView addSubview:_promptView];
    
    _breakImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textfieldBgView.frame), CGRectGetMaxY(_promptView.frame), 300.0f, 1.0f)];
    _breakImageView.center = CGPointMake(CGRectGetMidX(self.contentView.frame), _breakImageView.center.y);
    [_breakImageView setImage:[UIImage imageNamed:@"dashed"]];
    [self.contentView addSubview:_breakImageView];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(textfieldBgView.frame), CGRectGetMaxY(_breakImageView.frame) + 15.0f, 300.0f, 57.0f)];
    _confirmButton.center = CGPointMake(CGRectGetMidX(self.contentView.frame), _confirmButton.center.y);
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    _confirmButton.layer.cornerRadius = 5.0f;
    _confirmButton.clipsToBounds = YES;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_confirmButton];
}

- (void)hideKeyborad
{
    [_takeOutTextField resignFirstResponder];
}

-(void)backToPreviousView:(id)sender
{
    [self hideKeyborad];
    
    if(!_isBackToMenuControl) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    SLBMenuViewController *slbMenuViewCtrl = nil;
    for(id ctrl in self.navigationController.viewControllers) {
        if([ctrl isKindOfClass:[SLBMenuViewController class]]) {
            slbMenuViewCtrl = ctrl;
            break;
        }
    }
    
    if(slbMenuViewCtrl) {
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
    }
    else {
        slbMenuViewCtrl = [[SLBMenuViewController alloc] init];
        NSMutableArray *mtlViewCtrls = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mtlViewCtrls insertObject:slbMenuViewCtrl atIndex:mtlViewCtrls.count - 2];
        [slbMenuViewCtrl release];
        [self.navigationController setViewControllers:mtlViewCtrls animated:NO];
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
    }
}

- (void)confirmButtonTouched:(id)sender
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000030"];
    
    [_takeOutTextField resignFirstResponder];
    
    NSString *amountString = _takeOutTextField.text;
    
    if (amountString == nil || amountString.length < 1) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请输入转出金额" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([SLBHelper conformToAmtFormat:amountString] == NO) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"输入金额格式有误" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if([amountString floatValue] < _minOut || [amountString floatValue] <= 0) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:[NSString stringWithFormat:@"输入金额需大于%0.2f元", MAX(_minOut, 0)] notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if([amountString floatValue] > _totalAsset) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:[NSString stringWithFormat:@"输入金额需小于%0.2f元", _totalAsset] notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [self startTakeOutAmount:amountString];
}

- (void)startTakeOutAmount:(NSString *)amount
{
    NSString *serNumber30 = [NSString slbSerialNumberWithLength:30];
    [[SLBService sharedService].changeAmountSer requestForServeNum:serNumber30 changeType:SLBChangeOut changeAmt:amount target:self action:@selector(takeOutDidFinished:)];
}

- (void)takeOutDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *resDict = (NSDictionary *)request.responseAsJson;
    NSString *succAmtStr = [resDict safeJsonObjForKey:@"succAmt"];
    if(succAmtStr && succAmtStr.length > 0) {
        CGFloat succAmt = [succAmtStr floatValue];
        
        SLBDepositOrTakeOutResultViewController *resultViewCtrl = [[SLBDepositOrTakeOutResultViewController alloc] init];
        resultViewCtrl.resultType = SLBResultTakeOut;
        resultViewCtrl.amountChanged = succAmt;
        [self.navigationController pushViewController:resultViewCtrl animated:YES];
        [resultViewCtrl setNavigationTitle:self.naviTitleLabel.text];
        [resultViewCtrl release];
    }
    else {
        @autoreleasepool {
            NSString *respMsg = [resDict stringObjectForKey:@"respMsg"];
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:respMsg notifyType:NOTIFICATION_TYPE_WARNING];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = [touch view];
    if([touchView isKindOfClass:[UIControl class]]) {
        return (NO);
    }
    return (YES);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = textField.text;
    
    if([NSString isBackString:string])
    {
        return (YES);
    }
    
    if(text && text.length >= 32)
    {
        return (NO);
    }
    
    if(string.length > 1) {
        //        [textField resignFirstResponder];
        //        @autoreleasepool {
        //            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请不要粘贴内容到此输入框"
        //                                                                         notifyType:NOTIFICATION_TYPE_ERROR];
        //        }
        
        return (NO);
    } else if([NSString string:string isRangeOfString:@".0123456789"]) {
        //为空
        if(!text)
        {
            return (YES);
        }
        
        //没有小数点
        if([text rangeOfString:@"."].length == 0)
        {
            if([text isEqualToString:@"0"])
            {
                //0后面只能接小数点
                if([string isEqualToString:@"0"])
                {
                    return (NO);
                }
                else if(![string isEqualToString:@"."])
                {
                    textField.text = @"";
                }
            }
            return (YES);
        }
        
        NSArray *arr = [text componentsSeparatedByString:@"."];
        //多个小数点
        if(arr && arr.count >= 2 && [string isEqualToString:@"."])
        {
            return (NO);
        }
        
        //小数点没2位
        NSString *twoPtString = arr.lastObject;
        if(twoPtString.length < 2)
        {
            return (YES);
        }
        else
        {
            return (NO);
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入内容必须为金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
        return (NO);
    }
}

@end
