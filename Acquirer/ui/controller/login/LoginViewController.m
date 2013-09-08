//
//  LoginViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "ActivateViewController.h"
#import "LoginTableCell.h"
#import "NSNotificationCenter+CP.h"
#import "Acquirer.h"
#import "AcquirerService.h"
#import "ACUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginTableView;

-(void)dealloc{
    [loginTableView release];
    [contentList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = NO;
        self.isShowTabBar = NO;
        
        contentList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpContentList{
    NSArray *titleList = [NSArray arrayWithObjects:@"机  构  号　|", @"操作员号　|", @"密　　码　|", nil];
    NSArray *placeHolderList = [NSArray arrayWithObjects:@"请输入机构号", @"请输入操作员号", @"请输入密码", nil];
    NSArray *keyboardTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:UIKeyboardTypeNumberPad],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],nil];
    NSArray *secureList = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:YES], nil];
    NSArray *maxLengthList = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],
                                                       [NSNumber numberWithInt:20],
                                                       [NSNumber numberWithInt:32],nil];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *loginBgImg = IS_IPHONE5 ? [UIImage imageNamed:@"sd_logo-568h@2x.png"]:[UIImage imageNamed:@"sd_logo"];
    UIImageView *loginBgImgView = [[[UIImageView alloc] init] autorelease];
    loginBgImgView.userInteractionEnabled = YES;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.image = loginBgImg;
    
    [self.bgImageView addSubview:loginBgImgView];
    [self.bgImageView sendSubviewToBack:loginBgImgView];
    
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
     
    CGRect tableFrame = CGRectMake(0, 90, contentWidth, 160);
    self.loginTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    loginTableView.scrollEnabled = NO;
    loginTableView.backgroundColor = [UIColor clearColor];
    loginTableView.backgroundView = nil;
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    [self.contentView addSubview:loginTableView];
    loginTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginTableView.center.y);
    
    [self setUpContentList];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, 255, btnSelImg.size.width, btnSelImg.size.height);
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = buttonFrame;
    loginBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginBtn.center.y);
    loginBtn.backgroundColor = [UIColor clearColor];
    [loginBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    loginBtn.layer.cornerRadius = 10.0;
    loginBtn.clipsToBounds = YES;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:loginBtn];
    
    CGRect notLoginFrame = CGRectMake(0, 320, 120, 40);
    UIButton *notLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notLoginBtn.frame = notLoginFrame;
    notLoginBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), notLoginBtn.center.y);
    notLoginBtn.backgroundColor = [UIColor clearColor];
    notLoginBtn.titleLabel.font = [UIFont systemFontOfSize:19];//[UIFont fontWithName:@"Arial" size:19];
    [notLoginBtn setTitle:@"无法登录?" forState:UIControlStateNormal];
    [notLoginBtn setTitleColor:[Helper hexStringToColor:@"#CC0000"] forState:UIControlStateNormal];
    [notLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [notLoginBtn addTarget:self action:@selector(notLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:notLoginBtn];
    
    UILabel *serviceTitleLabel = [[[UILabel alloc] init] autorelease];
    serviceTitleLabel.bounds = CGRectMake(0, 0, 80, 30);
    serviceTitleLabel.backgroundColor = [UIColor clearColor];
    serviceTitleLabel.font = [UIFont systemFontOfSize:13];
    serviceTitleLabel.text = @"客服电话:";
    serviceTitleLabel.textColor = [Helper hexStringToColor:@"#666666"];
    serviceTitleLabel.center = CGPointMake(110, contentHeight-40);
    [self.contentView addSubview:serviceTitleLabel];
    
    UILabel *servicePhoneLabel = [[[UILabel alloc] init] autorelease];
    servicePhoneLabel.bounds = CGRectMake(0, 0, 150, 30);
    servicePhoneLabel.backgroundColor = [UIColor clearColor];
    servicePhoneLabel.font = [UIFont systemFontOfSize:15];
    servicePhoneLabel.text = @"021-33323999-5513";
    servicePhoneLabel.textColor = [Helper hexStringToColor:@"#4D77A4"];
    servicePhoneLabel.center = CGPointMake(210, contentHeight-41);
    [self.contentView addSubview:servicePhoneLabel];
    
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [contentView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissLoginViewController:)
                                                 name:NOTIFICATION_USER_LOGIN_SUCCEED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jumpToActivateViewController:)
                                                 name:NOTIFICATION_JUMP_ACTIVATE_PAGE
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dismissLoginViewController:(NSNotification *)notification{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)jumpToActivateViewController:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    
    ActivateViewController *activateCTRL = [[[ActivateViewController alloc] init] autorelease];
    activateCTRL.mobileSTR = [dict objectForKey:@"mobile"];
    [self.navigationController pushViewController:activateCTRL animated:YES];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.contentView];
    CGPoint convertPoint = [self.loginTableView convertPoint:point fromView:contentView];
    
    if (CGRectContainsPoint(self.loginTableView.bounds, convertPoint)) {
        return NO;
    }
    return YES;
}


-(void) tapGesture:(UITapGestureRecognizer *)sender{
    for (LoginTableCell *cell in [self.loginTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

-(void)login:(id)sender{
    NSArray *visibleCellList = [self.loginTableView visibleCells];
    for (LoginTableCell *cell in visibleCellList) {
        [cell.textField resignFirstResponder];
    }
    
    NSString *corpIdSTR = ((LoginTableCell *)[visibleCellList objectAtIndex:0]).textField.text;
    NSString *opratorIdSTR = ((LoginTableCell *)[visibleCellList objectAtIndex:1]).textField.text;
    NSString *passSTR = ((LoginTableCell *)[visibleCellList objectAtIndex:2]).textField.text;
    
    if ([Helper stringNullOrEmpty:corpIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"机构号为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([corpIdSTR rangeOfString:@"6"].location != 0){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"机构号有误，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return ;
    }
    
    if ([Helper stringNullOrEmpty:opratorIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"操作员号为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([Helper containInvalidChar:opratorIdSTR]){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"操作员号有误，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([Helper stringNullOrEmpty:passSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([Helper containInvalidChar:passSTR]){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"密码有误，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    ACUser *usr = [[[ACUser alloc] init] autorelease];
    usr.corpSTR = corpIdSTR;
    usr.opratorSTR = opratorIdSTR;
    usr.passSTR = passSTR;
    usr.state = USER_STATE_UNKNOWN;
    [Acquirer sharedInstance].currentUser = usr;
    
    [[AcquirerService sharedInstance] requestForLoginCorp:corpIdSTR oprator:opratorIdSTR pass:passSTR];
}

-(void)notLogin:(id)sender{
    NSLog(@"not login");
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
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}



@end
