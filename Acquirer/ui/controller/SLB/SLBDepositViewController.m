//
//  SLBDepositViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBMenuViewController.h"
#import "SLBDepositViewController.h"
#import "SLBDepositOrTakeOutResultViewController.h"
#import "SLBAttributedView.h"
#import "SLBService.h"
#import "SLBHelper.h"
#import "SafeObject.h"

@interface SLBDepositViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (retain, nonatomic) UILabel *canDepositHeaderLabel;
@property (retain, nonatomic) SLBAttributedView *canDepositAmountView;
@property (retain, nonatomic) UITextField *depositTextField;
@property (retain, nonatomic) SLBAttributedView *promptView;
@property (retain, nonatomic) UIImageView *breakImageView;
@property (retain, nonatomic) UIButton *confirmButton;

@property (assign, nonatomic) CGFloat minIn;
@property (assign, nonatomic) CGFloat maxIn;
@property (assign, nonatomic) CGFloat settleFund;

@end

@implementation SLBDepositViewController

- (void)dealloc
{
    [_canDepositHeaderLabel release];
    _canDepositHeaderLabel = nil;
    
    [_canDepositAmountView release];
    _canDepositAmountView = nil;
    
    [_depositTextField release];
    _depositTextField = nil;
    
    [_promptView release];
    _promptView = nil;
    
    [_breakImageView release];
    _breakImageView = nil;
    
    [_confirmButton release];
    _confirmButton = nil;
    
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
        _isNeedfresh = YES;
        
        _canDepositHeaderLabel = nil;
        _canDepositAmountView = nil;
        _depositTextField = nil;
        _promptView = nil;
        _breakImageView = nil;
        _confirmButton = nil;
        
        _minIn = 0;
        _maxIn = 0;
        _settleFund = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"存入"];
    
    [self addViews];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
    tapGesture.delegate = self;
    [self.contentView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_isNeedfresh)
    {
        _isNeedfresh = NO;
        [self reloadData];
    }
}

- (void)reloadData
{
    SLBUser *usr = [SLBService sharedService].slbUser;
    _minIn = [[usr safeObjectForKey:@"minIn"] floatValue];
    _maxIn = [[usr safeObjectForKey:@"maxIn"] floatValue];
    _settleFund = [[usr safeObjectForKey:@"settleFund"] floatValue];
    
    CGSize ctSize = self.contentView.bounds.size;
    
    CTParagraphStyleSetting amountAlignmentSetting;
    CTTextAlignment amountAlg = kCTTextAlignmentRight;
    amountAlignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    amountAlignmentSetting.value = &amountAlg;
    amountAlignmentSetting.valueSize = sizeof(CTTextAlignment);
    CTParagraphStyleSetting amountSettings[] = {amountAlignmentSetting};
    CTParagraphStyleRef amountParagraphStyle = CTParagraphStyleCreate(amountSettings, 1);
    
    NSString *amountStr = [[NSString micrometerSymbolAmount:_settleFund] stringByAppendingString:@"元"];
    NSMutableAttributedString *amountAttStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    
    CTFontRef amountCTFont18 = [UIFont systemFontOfSize:18].ctFont;
    CTFontRef amountCTFont10 = [UIFont systemFontOfSize:10].ctFont;
    
    [amountAttStr beginEditing];
    [amountAttStr addAttribute:(id)kCTFontAttributeName value:(id)amountCTFont18 range:NSMakeRange(0, amountAttStr.length)];
    [amountAttStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:NSMakeRange(0, amountAttStr.length - 1)];
    [amountAttStr addAttribute:(id)kCTFontAttributeName value:(id)amountCTFont10 range:NSMakeRange(amountAttStr.length - 1, 1)];
    [amountAttStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)amountParagraphStyle range:NSMakeRange(0, amountAttStr.length)];
    [amountAttStr endEditing];
    
    CFRelease(amountCTFont18);
    CFRelease(amountCTFont10);
    CFRelease(amountParagraphStyle);
    
    [_canDepositAmountView setAttributeString:amountAttStr];
    [amountAttStr release];
    
    CGFloat amountWidth = _canDepositHeaderLabel.bounds.size.width;
    CGFloat amountHeight = [NSAttributedString heightOfAttributedString:_canDepositAmountView.attributeString WidthWidth:amountWidth];
    _canDepositAmountView.frame = CGRectMake(0, 0, amountWidth - 100.0f, amountHeight);
    _canDepositAmountView.center = CGPointMake(ctSize.width - CGRectGetMinX(_canDepositHeaderLabel.frame) - CGRectGetMidX(_canDepositAmountView.bounds), _canDepositHeaderLabel.center.y);
    
    _depositTextField.placeholder = [NSString stringWithFormat:@"转入金额不能小于%0.2f元", _minIn];
    NSString *depositString = [NSString stringWithFormat:@"温馨提示：\n1.最低存入金额为%0.2f元\n2.生利宝可帮您获取高于银行10倍左右的活期利息\n3.生利宝资金可可以随时转出，转出后会按正常结算\n时间到您的银行帐户", _minIn];
    NSMutableAttributedString *mtlAttStr = [[NSMutableAttributedString alloc] initWithString:depositString];
    
    NSRange redRangeMinIn = [mtlAttStr.string rangeOfString:[NSString stringWithFormat:@"%0.2f", _minIn]];
    NSRange redRange10 = [mtlAttStr.string rangeOfString:@"10倍"];
    
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
    
    CTFontRef depositTextCTFont12 = [UIFont systemFontOfSize:12].ctFont;
    
    [mtlAttStr beginEditing];
    [mtlAttStr addAttribute:(id)kCTFontAttributeName value:(id)depositTextCTFont12 range:NSMakeRange(0, mtlAttStr.length)];
    [mtlAttStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)notiParagraphStyle range:NSMakeRange(0, mtlAttStr.length)];
    [mtlAttStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:redRange10];
    [mtlAttStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:redRangeMinIn];
    [mtlAttStr endEditing];
    
    CFRelease(depositTextCTFont12);
    CFRelease(notiParagraphStyle);
    
    [_promptView setAttributeString:mtlAttStr];
    [mtlAttStr release];
}

- (void)addViews
{
    CGSize ctSize = self.contentView.bounds.size;
    CGFloat toLeft = 20.0f;
    _canDepositHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(toLeft, 5.0f, ctSize.width - toLeft * 2.0f, DEFAULT_ROW_HEIGHT + 5.0f)];
    _canDepositHeaderLabel.backgroundColor = [UIColor clearColor];
    _canDepositHeaderLabel.textAlignment = NSTextAlignmentLeft;
    _canDepositHeaderLabel.font = [UIFont systemFontOfSize:16];
    _canDepositHeaderLabel.text = @"可存入金额：";
    [self.contentView addSubview:_canDepositHeaderLabel];
    
    _canDepositAmountView = [[SLBAttributedView alloc] initWithFrame:_canDepositHeaderLabel.bounds];
    _canDepositAmountView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_canDepositAmountView];
    
    CGFloat txToLeft = 9.0f;
    UIImageView *textfieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake(txToLeft, CGRectGetMaxY(_canDepositHeaderLabel.frame), ctSize.width - txToLeft * 2.0f, DEFAULT_ROW_HEIGHT)];
    [textfieldBgView setImage:[UIImage imageNamed:@"BUTT_whi_on"]];
    textfieldBgView.layer.cornerRadius = 10.0f;
    textfieldBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textfieldBgView.layer.borderWidth = 1.0f;
    textfieldBgView.clipsToBounds = YES;
    [self.contentView addSubview:textfieldBgView];
    [textfieldBgView release];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_canDepositHeaderLabel.frame), CGRectGetMinY(textfieldBgView.frame), 100.0f, CGRectGetHeight(textfieldBgView.frame))];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = _canDepositHeaderLabel.font;
    titleLabel.font = _canDepositHeaderLabel.font;
    titleLabel.text = @"存入金额(元):";
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    _depositTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), CGRectGetWidth(textfieldBgView.frame) - CGRectGetMaxX(titleLabel.frame), CGRectGetHeight(titleLabel.frame))];
    _depositTextField.borderStyle = UITextBorderStyleNone;
    _depositTextField.font = titleLabel.font;
    _depositTextField.adjustsFontSizeToFitWidth = YES;
    _depositTextField.minimumFontSize = 10.0f;
    _depositTextField.textAlignment = NSTextAlignmentRight;
    _depositTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _depositTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _depositTextField.keyboardType =UIKeyboardTypeNumberPad;
    _depositTextField.delegate = self;
    [self.contentView addSubview:_depositTextField];
    
    CGFloat promptSpace = 15.0f;
    _promptView = [[SLBAttributedView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_canDepositHeaderLabel.frame), CGRectGetMaxY(textfieldBgView.frame) + promptSpace, CGRectGetWidth(textfieldBgView.frame) - CGRectGetMinX(_canDepositHeaderLabel.frame), 120.0f)];
    _promptView.backgroundColor = [UIColor clearColor];
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
    _confirmButton.enabled = NO;
}

- (void)hideKeyborad
{
    [_depositTextField resignFirstResponder];
}

-(void)backToPreviousView:(id)sender
{
    [self hideKeyborad];
    
    SLBMenuViewController *slbMenuViewCtrl = nil;
    for(id ctrl in self.navigationController.viewControllers)
    {
        if([ctrl isKindOfClass:[SLBMenuViewController class]])
        {
            slbMenuViewCtrl = ctrl;
            break;
        }
    }
    
    if(slbMenuViewCtrl)
    {
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
    }
    else
    {
        slbMenuViewCtrl = [[SLBMenuViewController alloc] init];
        [self.navigationController popToViewController:slbMenuViewCtrl animated:YES];
        [slbMenuViewCtrl release];
    }
}

- (void)confirmButtonTouched:(id)sender
{
    //统计码:00000028
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000028"];
    
    CGFloat nowAmount = [NSString amountFromMicrometerSymbolString:_depositTextField.text withOutString:@"元"];
    
    [_depositTextField resignFirstResponder];
    
    if(nowAmount < _minIn)
    {
//        @autoreleasepool {
//            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:[NSString stringWithFormat:@"输入金额需大于%0.2f元", MAX(_minIn, 0)]
//                                                                         notifyType:NOTIFICATION_TYPE_ERROR];
//        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"输入金额需大于%0.2f元", MAX(_minIn, 0)] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else if(nowAmount > _settleFund)
    {
//        @autoreleasepool {
//            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"输入金额需小于当前待结算金额"
//                                                                         notifyType:NOTIFICATION_TYPE_ERROR];
//        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入金额需小于当前待结算金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else
    {
        [self startDepositAmount:nowAmount];
    }
}

- (void)startDepositAmount:(CGFloat)amount
{
    NSString *serNumber30 = [NSString slbSerialNumberWithLength:30];
    [[SLBService sharedService].changeAmountSer requestForServeNum:serNumber30 changeType:SLBChangeIn changeAmt:amount taget:self action:@selector(depositDidFinished:)];
}

- (void)depositDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *resDict = (NSDictionary *)request.responseAsJson;
    NSString *succAmtStr = [resDict safeJsonObjForKey:@"succAmt"];
    if(succAmtStr && succAmtStr.length > 0)
    {
        CGFloat succAmt = [succAmtStr floatValue];
        
        SLBDepositOrTakeOutResultViewController *resultViewCtrl = [[SLBDepositOrTakeOutResultViewController alloc] init];
        resultViewCtrl.resultType = SLBResultDesposit;
        resultViewCtrl.amountChanged = succAmt;
        [self.navigationController pushViewController:resultViewCtrl animated:YES];
        [resultViewCtrl setNavigationTitle:self.naviTitleLabel.text];
        [resultViewCtrl release];
    }
    else
    {
        @autoreleasepool {
            NSString *respMsg = [resDict safeJsonObjForKey:@"respMsg"];
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:respMsg notifyType:NOTIFICATION_TYPE_WARNING];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = [touch view];
    if([touchView isKindOfClass:[UIControl class]])
    {
        return (NO);
    }
    return (YES);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(string.length > 1)
    {
//        @autoreleasepool {
//            [textField resignFirstResponder];
//            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请不要粘贴内容到此输入框"
//                                                                         notifyType:NOTIFICATION_TYPE_ERROR];
//        }
    }
    else
    {
        NSString *oldText = textField.text;
        CGFloat oldAmount = [NSString amountFromMicrometerSymbolString:oldText withOutString:@"元"];
        CGFloat newAmount = 0;
        
        if([NSString isBackString:string])
        {
            //NSLog(@"--- 退格 ---");
            newAmount = (float)((NSInteger)(oldAmount / 10));
            if(newAmount == 0)
            {
                textField.text = @"";
            }
            else
            {
                NSString *newText = [NSString micrometerSymbolAmount:newAmount];
                textField.text = newText;
            }
        }
        else
        {
            if([NSString string:string isRangeOfString:@"0123456789"])
            {
                newAmount = oldAmount * 10.0f + [string floatValue];
                if(newAmount > _maxIn || newAmount > _settleFund)
                {
                    NSLog(@"--- 超过限额 ---");
                    newAmount = MIN(_maxIn, _settleFund);
                }
                NSString *newText = [NSString micrometerSymbolAmount:newAmount];
                textField.text = newText;
            }
            else
            {
                [textField resignFirstResponder];
//                @autoreleasepool {
//                    [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"输入内容必须为金额"
//                                                                                 notifyType:NOTIFICATION_TYPE_ERROR];
//                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入内容必须为金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
        
        CGFloat nowAmount = [NSString amountFromMicrometerSymbolString:textField.text withOutString:@"元"];
        _confirmButton.enabled = textField.text && textField.text.length > 0 && nowAmount >= _minIn && nowAmount > 0;
    }
    
    return (NO);
}

@end
