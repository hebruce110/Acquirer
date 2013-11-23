//
//  TradeHSummaryViewController.m
//  Acquirer
//
//  Created by peer on 10/29/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeHSummaryViewController.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"

#import "TradeTDetailViewController.h"

@implementation TradeHSummaryViewController

@synthesize summaryTV;
@synthesize devIdSTR;
@synthesize beginDateSTR, endDateSTR;

-(void)dealloc{
    [summaryTV release];
    [summaryList release];
    
    [beginDateSTR release];
    [endDateSTR release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        summaryList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"查询结果"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    
    UIImage *detailImg = [[UIImage imageNamed:@"btn-bg-s.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.frame = CGRectMake(contentWidth-70-10, 0, 70, 30);
    [detailBtn setBackgroundImage:detailImg forState:UIControlStateNormal];
    [detailBtn setTitle:@"查看明细" forState:UIControlStateNormal];
    detailBtn.titleLabel.textColor = [UIColor whiteColor];
    detailBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [detailBtn addTarget:self action:@selector(pressCheckDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBgView addSubview:detailBtn];
    detailBtn.center = CGPointMake(detailBtn.center.x, CGRectGetMidY(self.naviBgView.bounds));
    
    self.summaryTV = [[[GeneralTableView alloc] initWithFrame:self.contentView.bounds
                                                      style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [summaryTV setTableHeaderView:marginView];
    [summaryTV setTableFooterView:marginView];
    [summaryTV setDelegateViewController:self];
    [summaryTV setGeneralTableDataSource:summaryList];
    summaryTV.scrollEnabled = YES;
    summaryTV.backgroundColor = [UIColor clearColor];
    summaryTV.backgroundView = nil;
    [self.contentView addSubview:summaryTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    NSDateFormatter *dsFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dsFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *sdFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [sdFormatter setDateFormat:@"yyyyMMdd"];
    
    NSString *beginDateParamSTR = [sdFormatter stringFromDate:[dsFormatter dateFromString:beginDateSTR]];
    NSString *endDateParamSTR = [sdFormatter stringFromDate:[dsFormatter dateFromString:endDateSTR]];
    
    if ([devIdSTR isEqualToString:@"全部"]) {
        self.devIdSTR = [NSString stringWithFormat:@"00000000"];
    }
    
    [[AcquirerService sharedInstance].sumService onRespondTarget:self];
    [[AcquirerService sharedInstance].sumService requestForTradeSummay:Summary_Type_History
                                                          withPnrDevId:devIdSTR
                                                              fromDate:beginDateParamSTR
                                                                toDate:endDateParamSTR];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 && indexPath.section==0) {
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000036"];
        
        TradeTDetailViewController *tradeDetailCTRL = [[[TradeTDetailViewController alloc] init] autorelease];
        tradeDetailCTRL.tradeType = TradeDetailHistory;
        tradeDetailCTRL.beginDateSTR = self.beginDateSTR;
        tradeDetailCTRL.endDateSTR = self.endDateSTR;
        tradeDetailCTRL.tradeType = TradeDetailHistory;
        [self.navigationController pushViewController:tradeDetailCTRL animated:YES];
    }
}

-(void)pressCheckDetail:(id)sender{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000015"];
    
    TradeTDetailViewController *tradeDetailCTRL = [[[TradeTDetailViewController alloc] init] autorelease];
    tradeDetailCTRL.tradeType = TradeDetailHistory;
    tradeDetailCTRL.beginDateSTR = self.beginDateSTR;
    tradeDetailCTRL.endDateSTR = self.endDateSTR;
    tradeDetailCTRL.tradeType = TradeDetailHistory;
    [self.navigationController pushViewController:tradeDetailCTRL animated:YES];
}

-(void)processSummaryData:(NSDictionary *)dict{
    NSDateFormatter *dsFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dsFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *sdFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [sdFormatter setDateFormat:@"yyyyMMdd"];
    
    //NSString *beginSTR = [dict objectForKey:@"beginDate"];
    //NSString *endSTR = [dict objectForKey:@"endDate"];
    //NSString *pnrDevIdSTR = [dict objectForKey:@"pnrDevId"];
    //NSString *totalIncAmtSTR = [dict objectForKey:@"pnrDevId"];
    //NSString *totalExpAmtSTR = [dict objectForKey:@"totalExpAmt"];
    //NSString *totalFeeAmtSTR = [dict objectForKey:@"totalFeeAmt"];
    NSString *totalNetAmtSTR = [dict objectForKey:@"totalNetAmt"];
    NSString *totalXpAmtSTR = [dict objectForKey:@"totalXpAmt"];
    NSString *totalXpCntSTR = [dict objectForKey:@"totalXpCnt"];
    NSString *totalXwAmtSTR = [dict objectForKey:@"totalXwAmt"];
    NSString *totalXwCntSTR = [dict objectForKey:@"totalXwCnt"];
    NSString *totalXqAmtSTR = [dict objectForKey:@"totalXqAmt"];
    NSString *totalXqCntSTR = [dict objectForKey:@"totalXqCnt"];
    NSString *totalXdAmtSTR = [dict objectForKey:@"totalXdAmt"];
    NSString *totalXdCntSTR = [dict objectForKey:@"totalXdCnt"];
    NSString *totalXrAmtSTR = [dict objectForKey:@"totalXrAmt"];
    NSString *totalXrCntSTR = [dict objectForKey:@"totalXrCnt"];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    PlainCellContent *netContent = [[PlainCellContent new] autorelease];
    netContent.titleSTR = @"总净额";
    netContent.textSTR = totalNetAmtSTR;
    netContent.cellStyle = Cell_Style_Unit;
    netContent.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [secOne addObject:netContent];
    
    if ([devIdSTR isEqualToString:@"00000000"]) {
        self.devIdSTR = [NSString stringWithFormat:@"全部"];
    }
    
    PlainCellContent *descContent = [[PlainCellContent new] autorelease];
    descContent.titleSTR = [NSString stringWithFormat:@"终端号：%@", devIdSTR];
    descContent.textSTR = [NSString stringWithFormat:@"日期：%@ 至 %@", beginDateSTR, endDateSTR];
    descContent.cellStyle = Cell_Style_UpDown;
    [secOne addObject:descContent];
    [summaryList addObject:secOne];
    
    NSArray *expenseTitleList = @[@"总消费金额：", @"总消费笔数：", @"总预授权完成金额：", @"总预授权完成笔数"];
    NSArray *expenseTextList = @[[NSString stringWithFormat:@"%@元", totalXpAmtSTR],
                                 [NSString stringWithFormat:@"%@笔", totalXpCntSTR],
                                 [NSString stringWithFormat:@"%@元", totalXwAmtSTR],
                                 [NSString stringWithFormat:@"%@笔", totalXwCntSTR]];
    NSMutableArray *secTwo = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<expenseTextList.count; i++) {
        PlainCellContent *cc = [[PlainCellContent new] autorelease];
        cc.titleSTR = [expenseTitleList objectAtIndex:i];
        cc.textSTR = [expenseTextList objectAtIndex:i];
        cc.cellStyle = Cell_Style_Plain;
        [secTwo addObject:cc];
    }
    [summaryList addObject:secTwo];
    
    NSArray *withdrawTitleList = @[@"总消费撤销金额", @"总消费撤销笔数", @"总预授权完成撤销金额", @"总预授权完成撤销笔数", @"退货金额", @"退货笔数"];
    NSArray *withdrawTextList = @[[NSString stringWithFormat:@"%@元", totalXqAmtSTR],
                                  [NSString stringWithFormat:@"%@笔", totalXqCntSTR],
                                  [NSString stringWithFormat:@"%@元", totalXdAmtSTR],
                                  [NSString stringWithFormat:@"%@笔", totalXdCntSTR],
                                  [NSString stringWithFormat:@"%@元", totalXrAmtSTR],
                                  [NSString stringWithFormat:@"%@笔", totalXrCntSTR]];
    
    NSMutableArray *secThree = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<withdrawTitleList.count; i++) {
        PlainCellContent *cc = [[PlainCellContent new] autorelease];
        cc.titleSTR = [withdrawTitleList objectAtIndex:i];
        cc.textSTR = [withdrawTextList objectAtIndex:i];
        cc.cellStyle = Cell_Style_Plain;
        [secThree addObject:cc];
    }
    [summaryList addObject:secThree];
    
    [summaryTV reloadData];
}

@end


















