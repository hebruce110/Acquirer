//
//  TransHomeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//
#import "TradeHomeViewController.h"
#import "TradeTSummaryViewController.h"
#import "TradeTDetailViewController.h"
#import "TradeSettleMgtViewController.h"
#import "TradeHScopeViewController.h"
#import "TradeHDetailViewController.h"
#import "SLBViewController.h"
#import "SLBAuthorizationAgreementViewController.h"
#import "SLBMenuViewController.h"
#import "SLBLatestYieldCell.h"
#import "SLBService.h"
#import "SLBHelper.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "MessageNumberData.h"

@implementation TradeHomeViewController

@synthesize tradeTableView;

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
    
    [tradeTableView release];
    [imageList release];
    
    [titleList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        imageList = [[NSArray arrayWithObjects:@"tradetodaygather.png",
                                                @"tradetodaylist.png",
                                                @"tradesettle.png",
                                                @"tradehistorylist.png",
                                                @"tradetodaylist", nil] retain];
        
        titleList = [[NSArray arrayWithObjects:@"今日刷卡汇总",
                                                @"今日刷卡明细",
                                                @"结算管理",
                                                @"历史刷卡汇总",
                                                @"历史刷卡明细", nil] retain];
        
        classList = [[NSArray arrayWithObjects: TradeTSummaryViewController.class,
                                                TradeTDetailViewController.class,
                                                TradeSettleMgtViewController.class,
                                                TradeHScopeViewController.class,
                                                TradeHDetailViewController.class, nil] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"刷卡交易"];
	
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGRect tradeFrame = CGRectMake(0, 10, contentWidth, contentHeight-20);
    self.tradeTableView = [[[UITableView alloc] initWithFrame:tradeFrame style:UITableViewStyleGrouped] autorelease];
    tradeTableView.delegate = self;
    tradeTableView.dataSource = self;
    tradeTableView.backgroundColor = [UIColor clearColor];
    tradeTableView.backgroundView = nil;
    
    [self.contentView addSubview:tradeTableView];
    
    [self addRightItem];
    
    [self setUpBadge];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpBadge) name:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //有无权限
    BOOL agent = [SLBHelper blFromSLBAgentSlbFlag:[Acquirer sharedInstance].currentUser.agentSlbFlag equalYESString:@"Y"];
    BOOL acctStat = [SLBHelper blFromSLBAgentSlbFlag:[Acquirer sharedInstance].currentUser.acctStat equalYESString:@"C"];
    //第一次进App
    BOOL isFirstTimeEnterApp = [SLBHelper isFirstTimeEnterSLB];
    if(agent && acctStat && isFirstTimeEnterApp)
    {
        SLBViewController *slbViewCtrl = [[SLBViewController alloc] init];
        [self.navigationController pushViewController:slbViewCtrl animated:YES];
        [slbViewCtrl release];
    }
}

- (void)setUpBadge
{
    NSUInteger msgCount = 0;//客服聊天不计在内[MessageNumberData messageCount];
    NSUInteger reportCount = [MessageNumberData reportCount];
    NSUInteger notifiCount = [MessageNumberData notificationCount];
    
    AppDelegate *delg = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delg.cpTabBar setBadge:msgCount + reportCount + notifiCount itemIndex:1];
}

- (void)addRightItem
{
    UIImage *rightItemImg = [UIImage imageNamed:@"nav-btn.png"];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[rightItemImg resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 6.0f, 10.0f, 6.0f)]
                               forState:UIControlStateNormal];
    rightItemButton.frame = CGRectMake(self.naviBgView.bounds.size.width - 70.0f, 0, 60.0f, 29.0f);
    rightItemButton.center = CGPointMake(rightItemButton.center.x, CGRectGetMidY(naviBgView.bounds));
    [rightItemButton setTitle:@"设置" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightItemButton addTarget:self action:@selector(rightItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBgView addSubview:rightItemButton];
}

- (void)rightItemButtonTouched:(id)sender
{
    SettingsViewController *settingsCtrl = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsCtrl animated:YES];
    [settingsCtrl release];
}

#pragma mark UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([SLBHelper blFromSLBAgentSlbFlag:[Acquirer sharedInstance].currentUser.agentSlbFlag equalYESString:@"Y"])
    {
        return (2);
    }
    
    return (1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
    {
        return (1);
    }
    return [titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1)
    {
        static NSString *slbCellIdentifier = @"slbCellIdentifier";
        
        SLBLatestYieldCell *cell = [tableView dequeueReusableCellWithIdentifier:slbCellIdentifier];
        
        if (cell==nil) {
            cell = [[[SLBLatestYieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slbCellIdentifier] autorelease];
        }
        
        cell.imgView.image = [UIImage imageNamed:@"SLB_icon_slb"];
        cell.tlLabel.text = @"生利宝";
        cell.tlLabel.font = [UIFont boldSystemFontOfSize:18];
        
        ACUser *usr = [Acquirer sharedInstance].currentUser;
        NSString *yieldString = usr.latestYield;
        if(yieldString && yieldString.length > 0)
        {
            NSString *showHdStr = @"最新收益率：";
            NSMutableString *showLatestYieldStr = [NSMutableString stringWithString:showHdStr];
            CGFloat yield = [yieldString floatValue];
            [showLatestYieldStr appendFormat:@"%0.2f％", yield];
            NSMutableAttributedString *mtlAttStr = [[NSMutableAttributedString alloc] initWithString:showLatestYieldStr];
            
            CTFontRef ctFont10 = [UIFont boldSystemFontOfSize:10].ctFont;
            CTFontRef ctFont18 = [UIFont boldSystemFontOfSize:20].ctFont;
            
            CTParagraphStyleSetting yieldAlignmentSetting;
            CTTextAlignment yieldAlg = kCTTextAlignmentRight;
            yieldAlignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
            yieldAlignmentSetting.value = &yieldAlg;
            yieldAlignmentSetting.valueSize = sizeof(CTTextAlignment);
            CTParagraphStyleSetting yieldSettings[] = {yieldAlignmentSetting};
            CTParagraphStyleRef yieldParagraphStyle = CTParagraphStyleCreate(yieldSettings, 1);
            
            [mtlAttStr beginEditing];
            [mtlAttStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont10 range:NSMakeRange(0, mtlAttStr.length)];
            [mtlAttStr addAttribute:(id)kCTFontAttributeName value:(id)ctFont18 range:NSMakeRange(showHdStr.length, mtlAttStr.length - (showHdStr.length + 1))];
            [mtlAttStr addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:NSMakeRange(showHdStr.length, mtlAttStr.length - (showHdStr.length + 1))];
            [mtlAttStr addAttribute:(id)kCTParagraphStyleAttributeName value:(id)yieldParagraphStyle range:NSMakeRange(0, mtlAttStr.length)];
            [mtlAttStr endEditing];
            
            CFRelease(ctFont10);
            CFRelease(ctFont18);
            CFRelease(yieldParagraphStyle);
            
            [cell.attView setAttributeString:mtlAttStr];
            [mtlAttStr release];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    static NSString *identifier = @"Trade_Main_Identifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [titleList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1)
    {
        [self updateSLBUserInfo];
        //统计码:00000024
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000024"];
    }
    else
    {
        Class ViewController = [classList objectAtIndex:indexPath.row];
        BaseViewController *CTRL = [[[ViewController alloc] init] autorelease];
        [self.navigationController pushViewController:CTRL animated:YES];
        
        if ([CTRL isKindOfClass:TradeTSummaryViewController.class]) {
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000010"];
        }else if ([CTRL isKindOfClass:TradeTDetailViewController.class]){
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000011"];
        }else if ([CTRL isKindOfClass:TradeSettleMgtViewController.class]){
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000012"];
        }
    }
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
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
        //到生利宝主界面
        SLBMenuViewController *slbMenuViewtrl = [[SLBMenuViewController alloc] init];
        slbMenuViewtrl.isNeedfresh = NO;
        [self.navigationController pushViewController:slbMenuViewtrl animated:YES];
        [slbMenuViewtrl release];
    }
    else if(acctStatC)
    {
        //未开户
        SLBAuthorizationAgreementViewController *authorizationViewCtrl = [[SLBAuthorizationAgreementViewController alloc] init];
        [self.navigationController pushViewController:authorizationViewCtrl animated:YES];
        [authorizationViewCtrl release];
    }
}

@end
