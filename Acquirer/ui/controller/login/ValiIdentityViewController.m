//
//  ValiIdentityViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ValiIdentityViewController.h"
#import "ActivateViewController.h"
#import "FormCellContent.h"
#import "FormTableCell.h"

@interface ValiIdentityViewController ()

@property (retain, nonatomic) UIButton *submitBtn;
@property (retain, nonatomic) NSTimer *checkTimer;

@end

@implementation ValiIdentityViewController

@synthesize bgScrollView;
@synthesize posOrderTableView, captchaTableView;
@synthesize authImgView;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [self.checkTimer invalidate];
    self.checkTimer = nil;
    
    self.submitBtn = nil;
    
    [bgScrollView release];
    
    [posOrderTableView release];
    [captchaTableView release];
    
    [authImgView release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        _submitBtn = nil;
        isShowNaviBar = YES;
        isShowTabBar = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"身份验证"];
    
    [self addSubViews];
    
    UITapGestureRecognizer *tg = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)] autorelease];
    [self.authImgView addGestureRecognizer:tg];
    [self.bgImageView addGestureRecognizer:tg];
    tg.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[AcquirerService sharedInstance].valiService onRespondTarget:self];
    [[AcquirerService sharedInstance].valiService requestForAuthImgURL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)addSubViews
{
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.bgScrollView = [[[UIScrollView alloc] initWithFrame:self.contentView.frame] autorelease];
    [self.bgImageView addSubview:bgScrollView];
    
    //remove contentView
    [self.contentView removeFromSuperview];
    contentView.frame = contentView.bounds;
    [bgScrollView addSubview:contentView];
    
    FormCellContent *posPattern = [[[FormCellContent alloc] init] autorelease];
    posPattern.titleSTR = @"订单号前8位：";
    posPattern.placeHolderSTR = @"POS小票订单号前8位";
    posPattern.maxLength = 8;
    posPattern.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableArray *posSec = [[[NSMutableArray alloc] init] autorelease];
    [posSec addObject:posPattern];
    NSMutableArray *posList = [[[NSMutableArray alloc] init] autorelease];
    [posList addObject:posSec];
    
    CGRect posOrdertableFrame = CGRectMake(0, 10, contentWidth, 60);
    self.posOrderTableView = [[[GeneralTableView alloc] initWithFrame:posOrdertableFrame style:UITableViewStyleGrouped] autorelease];
    posOrderTableView.scrollEnabled = NO;
    posOrderTableView.backgroundColor = [UIColor clearColor];
    posOrderTableView.backgroundView = nil;
    [self.contentView addSubview:posOrderTableView];
    //posOrderTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), posOrderTableView.center.y);
    [posOrderTableView setGeneralTableDataSource:posList];
    
    UIImage *orderEgImg = [UIImage imageNamed:@"order_eg.png"];
    UIImageView *orderEgImgView = [[[UIImageView alloc] initWithImage:orderEgImg] autorelease];
    orderEgImgView.frame = CGRectMake(0, 80, orderEgImg.size.width, orderEgImg.size.height);
    orderEgImgView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), orderEgImgView.center.y);
    [self.contentView addSubview:orderEgImgView];
    
    FormCellContent *captchaPattern = [[[FormCellContent alloc] init] autorelease];
    captchaPattern.titleSTR = @"验证码：";
    captchaPattern.placeHolderSTR = @"验证码";
    captchaPattern.maxLength = 4;
    captchaPattern.keyboardType = UIKeyboardTypeAlphabet;
    captchaPattern.scrollOffset = CGPointMake(0, 100);
    NSMutableArray *captchaSec = [[[NSMutableArray alloc] init] autorelease];
    [captchaSec addObject:captchaPattern];
    NSMutableArray *captchaList = [[[NSMutableArray alloc] init] autorelease];
    [captchaList addObject:captchaSec];
    
    CGRect tableFrame = CGRectMake(0, 220, 170, 60);
    self.captchaTableView = [[[GeneralTableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    captchaTableView.scrollEnabled = NO;
    captchaTableView.backgroundColor = [UIColor clearColor];
    captchaTableView.backgroundView = nil;
    [self.contentView addSubview:captchaTableView];
    [captchaTableView setGeneralTableDataSource:captchaList];
    [captchaTableView setDelegateViewController:self];
    
    UIImage *authImg = [UIImage imageNamed:@"auth_loading.png"];
    self.authImgView = [[[UIImageView alloc] initWithImage:authImg] autorelease];
    authImgView.userInteractionEnabled = YES;
    authImgView.frame = CGRectMake(190, 0, authImg.size.width, authImg.size.height);
    authImgView.center = CGPointMake(authImgView.center.x, captchaTableView.center.y);
    [self.contentView addSubview:authImgView];
    
    UILabel *descLabel = [[[UILabel alloc] init] autorelease];
    descLabel.bounds = CGRectMake(0, 0, 85, 20);
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.text = @"点击图片刷新";
    [self.contentView addSubview:descLabel];
    descLabel.center = CGPointMake(authImgView.center.x, authImgView.center.y+35);
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(descLabel.frame)+VERTICAL_PADDING,
                                  dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UIImage *btnRSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnRDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, frameHeighOffset(dashImgView.frame)+VERTICAL_PADDING*2, btnRSelImg.size.width, btnRSelImg.size.height)];
    _submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), _submitBtn.center.y);
    _submitBtn.backgroundColor = [UIColor clearColor];
    [_submitBtn setBackgroundImage:btnRDeSelImg forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:btnRSelImg forState:UIControlStateSelected];
    _submitBtn.layer.cornerRadius = 10.0;
    _submitBtn.clipsToBounds = YES;
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [_submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.enabled = NO;
    [self.contentView addSubview:_submitBtn];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];
    
    if ([touchView isDescendantOfView:self.posOrderTableView] || [touchView isDescendantOfView:self.captchaTableView]) {
        return NO;
    }
    return YES;
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    CGPoint pointOfBg = [sender locationInView:self.bgImageView];
    CGPoint pointOfAuth = [self.authImgView convertPoint:pointOfBg fromView:self.bgImageView];
    
    if (CGRectContainsPoint(authImgView.bounds, pointOfAuth)) {
        [[AcquirerService sharedInstance].valiService onRespondTarget:self];
        [[AcquirerService sharedInstance].valiService requestForAuthImgURL];
        return;
    }
    
    for (FormTableCell *cell in [self.posOrderTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
    for (FormTableCell *cell in [self.captchaTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

-(void)refreshAuthImgView:(NSData *)imgData{
    UIImage *img = [UIImage imageWithData:imgData];
    self.authImgView.image = img;
}

-(void)submit:(id)sender{
    NSString *posOrderIdSTR = ((FormTableCell *)[[posOrderTableView visibleCells] objectAtIndex:0]).textField.text;
    NSString *authCodeSTR = ((FormTableCell *)[[captchaTableView visibleCells] objectAtIndex:0]).textField.text;
    
    if ([Helper stringNullOrEmpty:posOrderIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"订单号为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([posOrderIdSTR length] < 8){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"订单号为8位，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([Helper stringNullOrEmpty:authCodeSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"验证码为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([authCodeSTR length] != 4){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"验证码为４位，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [[AcquirerService sharedInstance].valiService onRespondTarget:self];
    [[AcquirerService sharedInstance].valiService requestForValidateIdentity:posOrderIdSTR withAuthCode:authCodeSTR];
}

-(void)pushToActivateViewController:(NSString *)mobileSTR{
    NSString *pnrDevIdSTR = ((FormTableCell *)[[posOrderTableView visibleCells] objectAtIndex:0]).textField.text;
    
    ActivateViewController *valiCTRL = [[[ActivateViewController alloc] init] autorelease];
    valiCTRL.CTRLType = ACTIVATE_VALIIDENTITY;
    valiCTRL.mobileSTR = mobileSTR;
    valiCTRL.pnrDevIdSTR = pnrDevIdSTR;
    [self.navigationController pushViewController:valiCTRL animated:YES];
    
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

//button enable
- (void)keyboardDidShow
{
    if(self.checkTimer)
    {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
    
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(checkTimerScheduled:) userInfo:nil repeats:YES];
}

- (void)keyboardDidHide
{
    if(self.checkTimer)
    {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
    }
}

- (void)checkTimerScheduled:(id)sender
{
    NSString *posOrderIdSTR = ((FormTableCell *)[[posOrderTableView visibleCells] objectAtIndex:0]).textField.text;
    NSString *authCodeSTR = ((FormTableCell *)[[captchaTableView visibleCells] objectAtIndex:0]).textField.text;
    
    _submitBtn.enabled = (posOrderIdSTR && authCodeSTR && (posOrderIdSTR.length > 7) && (authCodeSTR.length == 4));
}

@end
