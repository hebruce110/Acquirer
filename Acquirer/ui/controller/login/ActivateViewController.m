//
//  ActivateViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ActivateViewController.h"
#import "AcquirerService.h"
#import "Acquirer.h"
#import "FormCellContent.h"
#import "GeneralTableView.h"
#import "FormTableCell.h"
#import "ReviseMobileViewController.h"

#define DOWN_COUNT_VALUE 60

@interface ActivateViewController ()

@end

@implementation ActivateViewController

@synthesize bgScrollView, wrongMobileLabel;
@synthesize activateTableView, submitBtn;
@synthesize msgBtn, msgTimer;
@synthesize CTRLType;
@synthesize pnrDevIdSTR, mobileSTR;

-(void)dealloc{
    [bgScrollView release];
    [wrongMobileLabel release];
    
    [activateTableView release];
    [submitBtn release];
    
    [msgBtn release];
    [msgTimer release];
    
    [patternList release];
    
    [pnrDevIdSTR release];
    [mobileSTR release];

    [super dealloc];
}


-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        
        msgState = MSG_STATE_NORMAL;
        
        patternList = [[NSMutableArray alloc] init];
        downCount = DOWN_COUNT_VALUE;
    }
    return self;
}

-(void)setUpFormPatternList{
    NSArray *titleList = [NSArray arrayWithObjects:@"短信激活码：", @"新密码：", @"确认新密码：", nil];
    NSArray *placeHolderList = [NSArray arrayWithObjects:@"发送至手机的激活码", @"密码由6-20个字母、数字组成", @"再次输入新密码", nil];
    NSArray *keyboardTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:UIKeyboardTypeNumberPad],
                                 [NSNumber numberWithInt:UIKeyboardTypeAlphabet],
                                 [NSNumber numberWithInt:UIKeyboardTypeAlphabet],nil];
    NSArray *secureList = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES], nil];
    NSArray *maxLengthList = [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
                              [NSNumber numberWithInt:20],
                              [NSNumber numberWithInt:20],nil];
    
    for (int i=0; i<[titleList count]; i++) {
        FormCellContent *pattern = [[[FormCellContent alloc] init] autorelease];
        pattern.titleSTR = [titleList objectAtIndex:i];
        pattern.placeHolderSTR = [placeHolderList objectAtIndex:i];
        pattern.keyboardType = [[keyboardTypeList objectAtIndex:i] integerValue];
        pattern.secure = [[secureList objectAtIndex:i] boolValue];
        pattern.maxLength = [[maxLengthList objectAtIndex:i] integerValue];
        pattern.scrollOffset = CGPointMake(0, 150);
        [patternList addObject:pattern];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"账号激活"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.bgScrollView = [[[UIScrollView alloc] initWithFrame:self.contentView.frame] autorelease];
    [self.bgImageView addSubview:bgScrollView];
    
    //remove contentView
    [self.contentView removeFromSuperview];
    contentView.frame = contentView.bounds;
    [bgScrollView addSubview:contentView];
    
    CGRect introFrame ;
    UILabel *introMsgLabel;
    if (CTRLType == ACTIVATE_FIRST_CONFIRM) {
        introFrame =  CGRectMake(20, 10, 280, 40);
        introMsgLabel = [[[UILabel alloc] initWithFrame:introFrame] autorelease];
        introMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        introMsgLabel.numberOfLines = 2;
        introMsgLabel.font = [UIFont systemFontOfSize:16];
        introMsgLabel.text = @"账号未激活,请输入以下信息，验证通过后可正常使用。";
        introMsgLabel.backgroundColor = [UIColor clearColor];
        introMsgLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:introMsgLabel];
    }else if (CTRLType == ACTIVATE_VALIIDENTITY){
        introFrame =  CGRectMake(20, 10, 280, 20);
        introMsgLabel = [[[UILabel alloc] initWithFrame:introFrame] autorelease];
        introMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        introMsgLabel.numberOfLines = 2;
        introMsgLabel.font = [UIFont systemFontOfSize:16];
        introMsgLabel.text = [NSString stringWithFormat:@"订单号前８位：%@", pnrDevIdSTR] ;
        introMsgLabel.backgroundColor = [UIColor clearColor];
        introMsgLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:introMsgLabel];
    }
    
    CGRect mobileFrame = CGRectMake(20, frameHeighOffset(introFrame)+VERTICAL_PADDING-5, 200, 20);
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:mobileFrame];
    mobileLabel.font = [UIFont systemFontOfSize:16];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *blurMobileSTR = [mobileSTR stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    mobileLabel.text = [NSString stringWithFormat:@"手机号：%@", blurMobileSTR];
    [self.contentView addSubview:mobileLabel];
    
    wrongMobileLabel = nil;
    if (CTRLType == ACTIVATE_VALIIDENTITY) {
        self.wrongMobileLabel = [[[UILabel alloc] init] autorelease];
        wrongMobileLabel.frame = CGRectMake(190, 0, 120, 20);
        wrongMobileLabel.center = CGPointMake(wrongMobileLabel.center.x, mobileLabel.center.y);
        wrongMobileLabel.font = [UIFont systemFontOfSize:17];
        wrongMobileLabel.textColor = [Helper hexStringToColor:@"#1b538d"];
        wrongMobileLabel.backgroundColor = [UIColor clearColor];
        wrongMobileLabel.text = @"手机号码不对？";
        [self.contentView addSubview:wrongMobileLabel];
    }
    
    CGRect hintFrame = CGRectMake(20, frameHeighOffset(mobileFrame)+VERTICAL_PADDING-5, 280, 25);
    UILabel *hintMsgLabel = [[UILabel alloc] initWithFrame:hintFrame];
    hintMsgLabel.font = [UIFont boldSystemFontOfSize:13];
    hintMsgLabel.backgroundColor = [UIColor clearColor];
    hintMsgLabel.textAlignment = NSTextAlignmentLeft;
    hintMsgLabel.text = [NSString stringWithFormat:@"提示：该手机号是签订POS协议时预留的号码"];
    hintMsgLabel.textColor = [Helper hexStringToColor:@"#CC0000"];
    [self.contentView addSubview:hintMsgLabel];
    
    UIImage *btnWSelImg = [UIImage imageNamed:@"BUTT_whi_on.png"];
    UIImage *btnWDeSelImg = [UIImage imageNamed:@"BUTT_whi_off.png"];
    CGRect activateFrame = CGRectMake(0, frameHeighOffset(hintFrame)+VERTICAL_PADDING, btnWSelImg.size.width, btnWSelImg.size.height);
    
    
    self.msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = activateFrame;
    msgBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), msgBtn.center.y);
    msgBtn.backgroundColor = [UIColor clearColor];
    [msgBtn setBackgroundImage:btnWDeSelImg forState:UIControlStateNormal];
    [msgBtn setBackgroundImage:btnWSelImg forState:UIControlStateSelected];
    msgBtn.layer.cornerRadius = 10.0;
    msgBtn.clipsToBounds = YES;
    msgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17]; //[UIFont fontWithName:@"Arial" size:22];
    [msgBtn setTitle:@"获取激活码" forState:UIControlStateNormal];
    
    [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [msgBtn addTarget:self action:@selector(retriveActivateCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:msgBtn];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(activateFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    [self setUpFormPatternList];
    CGRect tableFrame = CGRectMake(0, frameHeighOffset(dashFrame)+VERTICAL_PADDING-5, contentWidth, 150);
    self.activateTableView = [[[GeneralTableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    activateTableView.scrollEnabled = NO;
    activateTableView.backgroundColor = [UIColor clearColor];
    activateTableView.backgroundView = nil;
    [self.contentView addSubview:activateTableView];
    
    [activateTableView setGeneralTableDataSource:[NSMutableArray arrayWithObject:patternList]];
    [activateTableView setDelegateViewController:self];
    
    
    UIImageView *dashImgViewCopy = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgViewCopy.frame = CGRectMake(0, frameHeighOffset(tableFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    dashImgViewCopy.center = CGPointMake(self.contentView.center.x, dashImgViewCopy.center.y);
    [self.contentView addSubview:dashImgViewCopy];
    
    UIImage *btnRSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnRDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, frameHeighOffset(dashImgViewCopy.frame)+VERTICAL_PADDING, btnRSelImg.size.width, btnRSelImg.size.height);
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnRDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnRSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.bgImageView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
    
    self.msgTimer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture]
                                             interval:1.0
                                               target:self
                                             selector:@selector(timerEvent:)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:msgTimer forMode:NSDefaultRunLoopMode];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];
    if ([touchView isDescendantOfView:self.activateTableView]) {
        return NO;
    }
    
    return YES;
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    if (CTRLType == ACTIVATE_VALIIDENTITY && self.wrongMobileLabel){
        CGPoint pointOfBg = [sender locationInView:self.bgImageView];
        CGPoint pointOfWrongMobile = [self.wrongMobileLabel convertPoint:pointOfBg fromView:self.bgImageView];
        if (CGRectContainsPoint(wrongMobileLabel.bounds, pointOfWrongMobile)) {
            
            ReviseMobileViewController *reviseCTRL = [[[ReviseMobileViewController alloc] init] autorelease];
            reviseCTRL.pnrDevIdSTR = pnrDevIdSTR;
            [self.navigationController pushViewController:reviseCTRL animated:YES];
            
            return;
        }
    }
    
    for (FormTableCell *cell in [self.activateTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

//恢复发送短信的状态
-(void)restoreShortMessageState{
    [msgTimer setFireDate:[NSDate distantFuture]];
    downCount = DOWN_COUNT_VALUE;
    msgState = MSG_STATE_NORMAL;
    msgBtn.enabled = YES;
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [msgBtn setTitle:@"获取激活码" forState:UIControlStateNormal];
}

-(void)disableShortMessageForOneMinute{
    msgBtn.enabled = NO;
    downCount = DOWN_COUNT_VALUE;
    msgState = MSG_STATE_SUCCEED;
    [msgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [msgTimer setFireDate:[NSDate distantPast]];
}

//短信倒计时timer
-(void)timerEvent:(NSTimer *)timer{
    if (downCount > 0) {
        if (msgState == MSG_STATE_NORMAL) {
            [msgBtn setTitle:[NSString stringWithFormat:@"（%d秒）重新发送激活码", downCount] forState:UIControlStateNormal];
        }else{
            [msgBtn setTitle:[NSString stringWithFormat:@"（%d秒）恢复获取激活码", downCount] forState:UIControlStateNormal];
        }
        downCount--;
    }else{
        [self restoreShortMessageState];
    }
}

-(void)retriveActivateCode:(id)sender{
    
    msgBtn.enabled = NO;
    [msgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [msgTimer setFireDate:[NSDate distantPast]];
    
    [[AcquirerService sharedInstance].msgService onRespondTarget:self];
    [[AcquirerService sharedInstance].msgService requestForShortMessage];
}

-(void)submit:(id)sender{
    NSArray *visibleCellList = [activateTableView visibleCells];
    NSString *msgCode = ((FormTableCell *)[visibleCellList objectAtIndex:0]).textField.text;
    NSString *passSTR = ((FormTableCell *)[visibleCellList objectAtIndex:1]).textField.text;
    NSString *confirmPassSTR = ((FormTableCell *)[visibleCellList objectAtIndex:2]).textField.text;
    
    if ([Helper stringNullOrEmpty:msgCode]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"短信激活码为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([Helper stringNullOrEmpty:passSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([Helper stringNullOrEmpty:passSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码为空，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([passSTR length] < 6){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码长度不能小于６位"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if (![passSTR isEqualToString:confirmPassSTR]){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"输入密码不一致，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000003"];
    
    [[AcquirerService sharedInstance].logService onRespondTarget:self];
    [[AcquirerService sharedInstance].logService requestForActivateLogin:msgCode withPass:passSTR];
}

static BOOL isShowTextEditing = NO;
-(void)adjustForTextFieldDidBeginEditing:(UITextField *)textField contentOffset:(CGPoint)offset{
    if (isShowTextEditing == NO) {
        [bgScrollView setContentOffset:offset animated:YES];
        isShowTextEditing = YES;
    }
}

-(void)adjustForTextFieldDidEndEditing:(UITextField *)textField contentOffset:(CGPoint)offset{
    isShowTextEditing = NO;
    [bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end











