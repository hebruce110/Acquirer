//
//  ActivateViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ActivateViewController.h"
#import "LoginTableCell.h"
#import "AcquirerService.h"

#define DOWN_COUNT_VALUE 60

@interface ActivateViewController ()

@end

@implementation ActivateViewController

@synthesize bgScrollView, activateTableView, submitBtn;
@synthesize msgBtn, msgTimer;
@synthesize mobileSTR;

-(void)dealloc{
    [bgScrollView release];
    [activateTableView release];
    [submitBtn release];
    
    [msgBtn release];
    [msgTimer release];
    
    [contentList release];
    [mobileSTR release];
    
    [msgService release];
    [super dealloc];
}


-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        
        msgState = MSG_STATE_NORMAL;
        
        contentList = [[NSMutableArray alloc] init];
        downCount = DOWN_COUNT_VALUE;
        
        msgService = [[MessageService alloc] init];
        [msgService onRespondTarget:self];
    }
    return self;
}

-(void)setUpContentList{
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
        LoginCellContent *content = [[[LoginCellContent alloc] init] autorelease];
        content.titleSTR = [titleList objectAtIndex:i];
        content.placeHolderSTR = [placeHolderList objectAtIndex:i];
        content.keyboardType = [[keyboardTypeList objectAtIndex:i] integerValue];
        content.secure = [[secureList objectAtIndex:i] boolValue];
        content.maxLength = [[maxLengthList objectAtIndex:i] integerValue];
        [contentList addObject:content];
    }
}

#define VERTICAL_PADDING 10

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
    
    CGRect introFrame = CGRectMake(20, 10, 280, 40);
    UILabel *introMsgLabel = [[[UILabel alloc] initWithFrame:introFrame] autorelease];
    introMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introMsgLabel.numberOfLines = 2;
    introMsgLabel.font = [UIFont systemFontOfSize:16];
    introMsgLabel.text = @"账号未激活,请输入以下信息，验证通过后可正常使用。";
    introMsgLabel.backgroundColor = [UIColor clearColor];
    introMsgLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:introMsgLabel];
    
    CGRect mobileFrame = CGRectMake(20, frameHeighOffset(introFrame)+VERTICAL_PADDING-5, 200, 20);
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:mobileFrame];
    mobileLabel.font = [UIFont systemFontOfSize:16];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *blurMobileSTR = [mobileSTR stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    mobileLabel.text = [NSString stringWithFormat:@"手机号：%@", blurMobileSTR];
    [self.contentView addSubview:mobileLabel];
    
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
    
    CGRect tableFrame = CGRectMake(0, frameHeighOffset(dashFrame)+VERTICAL_PADDING-5, contentWidth, 150);
    self.activateTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    activateTableView.scrollEnabled = NO;
    activateTableView.backgroundColor = [UIColor clearColor];
    activateTableView.backgroundView = nil;
    activateTableView.delegate = self;
    activateTableView.dataSource = self;
    [self.contentView addSubview:activateTableView];
    [self setUpContentList];
    
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
    CGPoint point = [touch locationInView:self.bgImageView];
    CGPoint convertPoint = [self.activateTableView convertPoint:point fromView:contentView];
    if (CGRectContainsPoint(self.activateTableView.bounds, convertPoint)) {
        return NO;
    }
    return YES;
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    for (LoginTableCell *cell in [self.activateTableView visibleCells]) {
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
    [msgService requestForShortMessage];
}

-(void)submit:(id)sender{
    NSArray *visibleCellList = [activateTableView visibleCells];
    NSString *msgCode = ((LoginTableCell *)[visibleCellList objectAtIndex:0]).textField.text;
    NSString *passSTR = ((LoginTableCell *)[visibleCellList objectAtIndex:1]).textField.text;
    
    [[AcquirerService sharedInstance] requestForActivateLogin:msgCode withPass:passSTR];
}

static BOOL isShowTextEditing = NO;
-(void)adjustForTextFieldDidBeginEditing:(UITextField *)textField{
    if (isShowTextEditing == NO) {
        [bgScrollView setContentOffset:CGPointMake(0, 160) animated:YES];
        isShowTextEditing = YES;
    }
}

-(void)adjustForTextFieldDidEndEditing:(UITextField *)textField{
    isShowTextEditing = NO;
    [bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Login_Identifier";
    
    LoginTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[LoginTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContent:[contentList objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    [cell adjustForActivateViewController];
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end











