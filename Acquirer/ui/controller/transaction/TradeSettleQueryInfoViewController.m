//
//  TradeSettleQueryInfoViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleQueryInfoViewController.h"
#import "PlainCellContent.h"

@implementation TradeSettleQueryInfoViewController

@synthesize sqContent;
@synthesize settleTV;

-(void)dealloc{
    [sqContent release];
    
    [settleList release];
    [settleTV release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        settleList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"结算详情"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.settleTV = [[[GeneralTableView alloc] initWithFrame:self.contentView.bounds
                                                           style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [settleTV setTableHeaderView:marginView];
    [settleTV setTableFooterView:marginView];
    [settleTV setGeneralTableDataSource:settleList];
    settleTV.scrollEnabled = YES;
    settleTV.backgroundColor = [UIColor clearColor];
    settleTV.backgroundView = nil;
    [self.contentView addSubview:settleTV];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [settleList removeAllObjects];
    [[AcquirerService sharedInstance].settleService onRespondTarget:self];
    [[AcquirerService sharedInstance].settleService requestForSettleInfo:sqContent];
}

-(void)processSettleQueryInfoData:(NSDictionary *)dict{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *baldate = [formatter dateFromString:[dict objectForKey:@"balDate"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *settleDateSTR = [formatter stringFromDate:baldate];
    NSString *settleTypeSTR = @"即时结算";
    //即时结算总金额
    NSString *settlePTotalAmtSTR = [NSString stringWithFormat:@"%@元", [dict objectForKey:@"pTotalBalAmt"]];
    //即时结算手续费
    NSString *settlePFeeAmtSTR = [NSString stringWithFormat:@"%@元", [dict objectForKey:@"pFeeAmt"]];
    //即时结算的状态
    NSString *settlePStatSTR = [[Acquirer sharedInstance] settleStatDesc:[dict objectForKey:@"pBalStat"]];
    
    //总结算金额
    NSString *settleTotalAmtSTR = [NSString stringWithFormat:@"%@元", [dict objectForKey:@"totalBalAmt"]];
    NSString *settleStatSTR = [[Acquirer sharedInstance] settleStatDesc:[dict objectForKey:@"balStat"]];
    
    NSString *acctIdSTR = [dict objectForKey:@"acctId"];
    NSString *acctNameSTR = [dict objectForKey:@"acctName"];
    NSString *bankNameSTR = [dict objectForKey:@"bankName"];
    NSString *bankAddrSTR = [dict objectForKey:@"bankAddr"];
    NSString *branchNameSTR = [dict objectForKey:@"branchName"];
    
    //结算状态信息, 上半部分section
    NSMutableArray *settleStateList = [[[NSMutableArray alloc] init] autorelease];
    //P表示查询即时结算详情
    if ([sqContent.cashChannelSTR isEqualToString:@"P"]) {
        NSArray *stateTitleList = @[@"结算日期:", @"结算类型:", @"总结算金额:", @"手续费:", @"结算状态:"];
        NSArray *stateTextList = @[settleDateSTR, settleTypeSTR, settlePTotalAmtSTR, settlePFeeAmtSTR, settlePStatSTR];
        for (int i=0; i<stateTitleList.count; i++) {
            PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
            pc.titleSTR = [stateTitleList objectAtIndex:i];
            pc.textSTR = [stateTextList objectAtIndex:i];
            pc.cellStyle = Cell_Style_Plain;
            [settleStateList addObject:pc];
        }
    }else{
        //H情况　T+1结算详情
        NSArray *stateTitleList = @[@"结算日期:", @"总结算金额:", @"结算状态:"];
        NSArray *stateTextList = @[settleDateSTR, settleTotalAmtSTR, settleStatSTR];
        for (int i=0; i<stateTitleList.count; i++) {
            PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
            pc.titleSTR = [stateTitleList objectAtIndex:i];
            pc.textSTR = [stateTextList objectAtIndex:i];
            pc.cellStyle = Cell_Style_Plain;
            [settleStateList addObject:pc];
        }
    }
    if (NotNilAndEqualsTo(dict, @"balStat", @"F") || NotNilAndEqualsTo(dict, @"pBalStat", @"F")) {
        PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
        pc.titleSTR = @"原因：";
        pc.textSTR = [[Acquirer sharedInstance] codeCSVDesc:[dict objectForKey:@"remarks"]];
        pc.cellStyle = Cell_Style_LineBreak;
        [settleStateList addObject:pc];
    }
    [settleList addObject:settleStateList];
    
    //结算信息, 下半部分section
    NSMutableArray *settleInfoList = [[[NSMutableArray alloc] init] autorelease];
    NSArray *infoTitleList = @[@"账号:", @"账户名:", @"账户银行:", @"开户地:", @"支行信息:"];
    NSArray *infoTextList = @[acctIdSTR, acctNameSTR, bankNameSTR, bankAddrSTR, branchNameSTR];
    for (int i=0; i<infoTitleList.count; i++) {
        PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
        pc.cellStyle = Cell_Style_Text_LineBreak;
        pc.titleSTR = [infoTitleList objectAtIndex:i];
        pc.textSTR = [infoTextList objectAtIndex:i];
        [settleInfoList addObject:pc];
    }
    
    [settleList addObject:settleInfoList];
    
    [settleTV setGeneralTableDataSource:settleList];
    [settleTV reloadData];
}

@end
