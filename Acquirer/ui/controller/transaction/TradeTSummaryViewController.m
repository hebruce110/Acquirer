//
//  TradeTGatherViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTSummaryViewController.h"
#import "SLBDepositViewController.h"
#import "TradeEncashViewController.h"
#import "SLBAuthorizationAgreementViewController.h"

#import "GeneralTableView.h"
#import "FormCellContent.h"
#import "PlainCellContent.h"
#import "PlainTableCell.h"
#import "UILabel+Size.h"

#import "SLBService.h"
#import "SLBHelper.h"
#import "SafeObject.h"

@interface TradeTSummaryViewController ()

@property (retain, nonatomic) NSMutableArray *textKeys;

@property (retain, nonatomic) NSDictionary *summaryDict;

@end

@implementation TradeTSummaryViewController

@synthesize summaryTV, summaryList;

-(void)dealloc{
    [summaryTV release];
    [summaryList release];
    self.textKeys = nil;
    self.summaryDict = nil;
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        isShowRefreshBtn = YES;
        self.isNeedRefresh = YES;
        summaryList = [[NSMutableArray alloc] init];
        _textKeys = [[NSMutableArray alloc] init];
        _summaryDict = [[NSDictionary alloc] init];
    }
    return self;
}

-(void)setUpSummaryList{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [summaryList removeAllObjects];
    
    NSArray *sectionOne = @[@"总净额", @"日期"];
    NSArray *sectionTwo = @[@"总消费金额", @"总消费笔数", @"总预授权完成金额", @"总预授权完成笔数"];
    NSArray *sectionThree = @[@"总消费撤销金额", @"总消费撤销笔数", @"总预授权完成撤销金额", @"总预授权完成撤销笔数", @"退货金额", @"退货笔数"];
    NSArray *templeList = @[sectionOne, sectionTwo, sectionThree];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *title in list) {
            NSMutableString *mtlTitle = [NSMutableString stringWithString:title];
            if(mtlTitle && mtlTitle.length > 0)
            {
                [mtlTitle appendString:@":"];
                
                [secList addObject:mtlTitle];
            }
        }
        [summaryList addObject:secList];
    }
    
    [_textKeys removeAllObjects];
    NSArray *sectionOneKeys = @[@"totalNetAmt", @"date"];
    NSArray *sectionTwoKeys = @[@"totalXpAmt", @"totalXpCnt", @"totalXwAmt", @"totalXwCnt"];
    NSArray *sectionThreeKeys = @[@"totalXqAmt", @"totalXqCnt", @"totalXdAmt", @"totalXdCnt", @"totalXrAmt", @"totalXrCnt"];
    [_textKeys addObject:sectionOneKeys];
    [_textKeys addObject:sectionTwoKeys];
    [_textKeys addObject:sectionThreeKeys];
    
    [pool drain];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"今日刷卡汇总"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [self setUpSummaryList];

    self.summaryTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)
                                                     style:UITableViewStyleGrouped] autorelease];
    [summaryTV setDataSource:self];
    [summaryTV setDelegate:self];
    summaryTV.backgroundColor = [UIColor clearColor];
    summaryTV.backgroundView = nil;
    [self.contentView addSubview:summaryTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.isNeedRefresh)
    {
        self.isNeedRefresh = NO;
        [self refreshCurrentTableView];
    }
}

-(void)refreshCurrentTableView{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *curDateSTR = [dateFormatter stringFromDate:[NSDate date]];
    
    [[AcquirerService sharedInstance].sumService onRespondTarget:self];
    [[AcquirerService sharedInstance].sumService requestForTradeSummay:Summary_Type_Today
                                                          withPnrDevId:@"00000000"
                                                              fromDate:curDateSTR
                                                                toDate:curDateSTR];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[summaryList objectAtIndex:section] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *summaryCellIdentifier = @"summaryCellIdentifier";
    PlainTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:summaryCellIdentifier];
    if (plaincell==nil) {
        plaincell = [[[PlainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:summaryCellIdentifier] autorelease];
    }
    
    NSString *title = [[summaryList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    plaincell.titleLabel.text = title;
    
    NSString *textkey = [[_textKeys objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    plaincell.textLabel.text = [_summaryDict stringObjectForKey:textkey];
    
    plaincell.textLabel.numberOfLines = [UILabel calcLabelLineWithString:title andFont:plaincell.textLabel.font lineWidth:plaincell.textLabel.bounds.size.width];
    [plaincell.textLabel setContentMode:UIViewContentModeCenter];
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        CGRect tlFm = plaincell.titleLabel.frame;
        tlFm.size.width = 260.0f;
        plaincell.titleLabel.frame = tlFm;
        
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *beginDate = [formatter stringFromDate:[NSDate date]];
        plaincell.titleLabel.textColor = plaincell.textLabel.textColor = [UIColor grayColor];
        plaincell.titleLabel.text = [NSString stringWithFormat:@"%@%@", title, beginDate];
        plaincell.textLabel.text = @"";
    }
    else
    {
        CGRect tlFm = plaincell.titleLabel.frame;
        tlFm.size.width = 180.0f;
        plaincell.titleLabel.frame = tlFm;
        plaincell.titleLabel.textColor = plaincell.textLabel.textColor = [UIColor blackColor];
        
        NSMutableString *mtlText = [NSMutableString stringWithString:plaincell.textLabel.text];
        NSString *apStr = (indexPath.row % 2 == 0) ? @"元" : @"笔";
        [mtlText appendString:apStr];
        plaincell.textLabel.text = mtlText;
    }
    
    plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return (plaincell);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (summaryList.count);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return (DEFAULT_ROW_HEIGHT);
    }
    return (0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (DEFAULT_ROW_HEIGHT);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, DEFAULT_ROW_HEIGHT)];
        
        CGFloat width = (CGRectGetWidth(vw.frame) - 40.0f) / 2.0f;
        UIButton *settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *depositButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settleButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateNormal];
        [settleButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateSelected];
        [settleButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateHighlighted];
        [depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateNormal];
        [depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateSelected];
        [depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateHighlighted];
        [settleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [depositButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [settleButton setTitle:@"即时结算" forState:UIControlStateNormal];
        [depositButton setTitle:@"存入生利宝" forState:UIControlStateNormal];
        settleButton.titleLabel.font = depositButton.titleLabel.font = [UIFont systemFontOfSize:14];
        settleButton.frame = CGRectMake(10.0f, 0, width, DEFAULT_ROW_HEIGHT - 10.0f);
        depositButton.frame = CGRectMake(CGRectGetMaxX(settleButton.frame) + 20.0f, CGRectGetMinY(settleButton.frame), CGRectGetWidth(settleButton.frame), CGRectGetHeight(settleButton.frame));
        [settleButton addTarget:self action:@selector(settleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [depositButton addTarget:self action:@selector(depositButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [vw addSubview:settleButton];
        [vw addSubview:depositButton];
        
        return ([vw autorelease]);
    }
    return (nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)settleButtonTouched:(id)sender
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000019"];
    
    [[AcquirerService sharedInstance].encashService onRespondTarget:self];
    [[AcquirerService sharedInstance].encashService requestForBalanceAuth];
}

- (void)depositButtonTouched:(id)sender
{
    [self updateSLBUserInfo];
    //统计码:00000024
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000024"];
}

-(void)processEncashData:(NSDictionary *)dict{
    EncashModel *em = [[[EncashModel alloc] init] autorelease];
    em.cashAmtSTR = [dict objectForKey:@"cashAmt"];
    em.avlBalSTR = [dict objectForKey:@"avlBal"];
    em.miniAmtSTR = [dict objectForKey:@"minAmt"];
    em.bankNameSTR = [dict objectForKey:@"bankName"];
    em.acctIdSTR = [dict objectForKey:@"acctId"];
    em.agentNameSTR = [dict objectForKey:@"agentName"];
    
    TradeEncashViewController *teCTRL = [[[TradeEncashViewController alloc] init] autorelease];
    teCTRL.ec = em;
    [self.navigationController pushViewController:teCTRL animated:YES];
}

#pragma mark - slb network
- (void)updateSLBUserInfo
{
    [[SLBService sharedService].querySer requestForQueryTarget:self action:@selector(updateSLBUserInfoDidFinished)];
}

- (void)updateSLBUserInfoDidFinished
{
    BOOL acctStatN = [SLBHelper blFromSLBAgentSlbFlag:[[SLBService sharedService].slbUser objectForKey:@"acctStat"] equalYESString:@"N"];
    BOOL acctStatC = [SLBHelper blFromSLBAgentSlbFlag:[[SLBService sharedService].slbUser objectForKey:@"acctStat"] equalYESString:@"C"];
    if(acctStatN)
    {
        SLBDepositViewController *depositViewCtrl = [[SLBDepositViewController alloc] init];
        depositViewCtrl.isBackToMenuControl = NO;
        [self.navigationController pushViewController:depositViewCtrl animated:YES];
        [depositViewCtrl release];
    }
    else if(acctStatC)
    {
        //未开户
        SLBAuthorizationAgreementViewController *authorizationViewCtrl = [[SLBAuthorizationAgreementViewController alloc] init];
        authorizationViewCtrl.isBackToMenuControl = NO;
        [self.navigationController pushViewController:authorizationViewCtrl animated:YES];
        [authorizationViewCtrl release];
    }
}

//处理汇总数据
-(void)processSummaryData:(NSDictionary *)dict{
    self.summaryDict = dict;
    
    [self.summaryTV reloadData];
}

@end
