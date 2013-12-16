//
//  SLBServeAgreementViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBServeAgreementViewController.h"
#import "SLBUserNotiDocViewController.h"
#import "SLBMenuViewController.h"
#import "SLBDepositViewController.h"
#import "SLBCheckBox.h"
#import "Acquirer.h"
#import "SLBService.h"
#import "SLBHelper.h"
#import "SafeObject.h"
#import "SLBServeUserInfoCell.h"

@interface SLBServeAgreementViewController () <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) UITableView *userInfoTableView;
@property (retain, nonatomic) SLBCheckBox *agreeBox;
@property (retain, nonatomic) UIButton *agreementButton;
@property (retain, nonatomic) UIButton *confirmButton;

@property (retain, nonatomic) NSMutableArray *infoArray;

@end

@implementation SLBServeAgreementViewController

- (void)dealloc
{
    self.userInfoTableView = nil;
    self.agreeBox = nil;
    self.agreementButton = nil;
    self.confirmButton = nil;
    self.infoArray = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
        
        _userInfoTableView = nil;
        _agreeBox = nil;
        _agreementButton = nil;
        _confirmButton = nil;
        _infoArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setUpInfoList
{
    @autoreleasepool {
        if(_infoArray) {
            [_infoArray removeAllObjects];
        }
        
        SLBUser *slbUsr = [SLBService sharedService].slbUser;
        NSString *fullName = [slbUsr safeObjectForKey:@"fullName"];
        NSString *certType = [slbUsr safeObjectForKey:@"certType"];
        NSString *certNo = [slbUsr safeObjectForKey:@"certNo"];
        NSString *cardNo = [slbUsr safeObjectForKey:@"cardNo"];
        NSString *mobile = [slbUsr safeObjectForKey:@"mobile"];
        NSString *prodiderName = [slbUsr safeObjectForKey:@"prodiderName"];
        
        NSArray *headerTitleArray = [NSArray arrayWithObjects:
                                     @"姓名:",
                                     [SLBHelper certNameFromCertType:certType],
                                     @"银行卡号:",
                                     @"手机号:",
                                     @"服务提供方:", nil];
        
        NSArray *textArray = [NSArray arrayWithObjects:
                              fullName,
                              certNo,
                              cardNo,
                              mobile,
                              prodiderName, nil];
        
        for(NSInteger index = 0; index < headerTitleArray.count; index ++) {
            NSString *title = [headerTitleArray safeObjectAtIndex:index];
            NSString *text = [textArray safeObjectAtIndex:index];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            [dict setObject:title forKey:@"title"];
            [dict setObject:text forKey:@"text"];
            [_infoArray addObject:dict];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"信息确认"];
    
    CGFloat space = 18.0f;
    
    [self setUpInfoList];
    
    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 246.0f) style:UITableViewStyleGrouped];
    _userInfoTableView.backgroundView = nil;
    _userInfoTableView.backgroundColor = [UIColor clearColor];
    _userInfoTableView.dataSource = self;
    _userInfoTableView.delegate = self;
    _userInfoTableView.scrollEnabled = NO;
    _userInfoTableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    [self.contentView addSubview:_userInfoTableView];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 57.0f)];
    _confirmButton.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMaxY(_userInfoTableView.frame) + 22.0f + space * 2.0f + _confirmButton.bounds.size.height * 0.5f);
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_confirmButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    _confirmButton.layer.cornerRadius = 5.0f;
    _confirmButton.clipsToBounds = YES;
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_confirmButton];
    
    _agreeBox = [[SLBCheckBox alloc] initWithFrame:CGRectMake(_confirmButton.frame.origin.x, CGRectGetMaxY(_userInfoTableView.frame) + space, 60.0f, 22.0f)];
    [_agreeBox addTarget:self action:@selector(agreeBoxTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_agreeBox setTitle:@"同意" font:[UIFont systemFontOfSize:16]];
    [_agreeBox setImage:[UIImage imageNamed:@"checkbox_nor"] forState:SLBCheckBoxStateDeSelected];
    [_agreeBox setImage:[UIImage imageNamed:@"checkbox_sle"] forState:SLBCheckBoxStateSelected];
    _agreeBox.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_agreeBox];
    
    _agreementButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_agreeBox.frame), _agreeBox.frame.origin.y, CGRectGetWidth(self.contentView.bounds) * 0.5f, _agreeBox.bounds.size.height)];
    [_agreementButton setTitleColor:[UIColor slbBlueColor] forState:UIControlStateNormal];
    [_agreementButton setTitle:@"《生利宝服务协议》" forState:UIControlStateNormal];
    [_agreementButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_agreementButton addTarget:self action:@selector(agreementButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_agreementButton];
    
    _agreeBox.isSelected = YES;
}

- (void)agreeBoxTouched:(id)sender
{
    _confirmButton.enabled = _agreeBox.isSelected;
}

- (void)agreementButtonTouched:(id)sender
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000034"];
    
    SLBUserNotiDocViewController *userNotiViewCtrl = [[SLBUserNotiDocViewController alloc] init];
    userNotiViewCtrl.agreementType = SLBUserNotiTypeServe;
    [self.navigationController pushViewController:userNotiViewCtrl animated:YES];
    [userNotiViewCtrl setNavigationTitle:@"生利宝服务协议"];
    [userNotiViewCtrl release];
}

- (void)confirmButtonTouched:(id)sender
{
    //统计码:00000025
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000025"];
    
    [self slbOpen];
}

#pragma mark - network stack
//开通
- (void)slbOpen
{
    [[SLBService sharedService].openSer requestForOpenTarget:self action:@selector(slbDidOpenFinished:)];
}

- (void)slbDidOpenFinished:(AcquirerCPRequest *)request
{
    NSArray *keys = [NSArray arrayWithObjects:
                     @"settleFund",
                     @"totalAsset",
                     @"curProfit",
                     @"totalProfit",
                     @"minIn",
                     @"maxIn",
                     @"minOut",
                     @"maxOut", nil];
    NSDictionary *body = (NSDictionary *)request.responseAsJson;

    SLBUser *slbUsr = [SLBService sharedService].slbUser;
    for(NSString *key in keys) {
        id value = [body safeJsonObjForKey:key];
        if(value) {
            [slbUsr setObject:value forKey:key];
        }
    }
    
    //开户成功后跳到存入界面
    NSArray *viewCtrls = self.navigationController.viewControllers;
    NSMutableArray *mtlViewCtrls = [NSMutableArray arrayWithArray:viewCtrls];
    
    SLBMenuViewController *slbMenuViewCtrl = [[SLBMenuViewController alloc] init];
    slbMenuViewCtrl.isNeedfresh = YES;
    [mtlViewCtrls addObject:slbMenuViewCtrl];
    [slbMenuViewCtrl release];
    
    SLBDepositViewController *depositViewCtrl = [[SLBDepositViewController alloc] init];
    [mtlViewCtrls addObject:depositViewCtrl];
    [depositViewCtrl release];
    
    [self.navigationController setViewControllers:mtlViewCtrls animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (DEFAULT_ROW_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_infoArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *serveAgreementCellIdentifier = @"serveAgreementCellIdentifier";
    SLBServeUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:serveAgreementCellIdentifier];
    if(!cell) {
        cell = [[[SLBServeUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serveAgreementCellIdentifier] autorelease];
    }
    
    NSDictionary *dict = [_infoArray safeObjectAtIndex:indexPath.row];
    cell.title = [dict stringObjectForKey:@"title"];
    cell.detailTitle = [dict stringObjectForKey:@"text"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return (cell);
}

@end
