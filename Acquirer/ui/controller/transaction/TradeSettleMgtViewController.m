//
//  TradeSettleViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleMgtViewController.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"
#import "TradeSettleScopeViewController.h"
#import "TradeSettleBankAcctViewController.h"
#import "TradeEncashViewController.h"

@implementation TradeSettleMgtViewController

@synthesize settleTV;

-(void)dealloc{
    [settleList release];
    [settleTV release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        settleList = [[NSMutableArray alloc] init];
        self.isNeedRefresh = YES;
    }
    return self;
}

-(void)setUpSettleList{
    NSArray *secListOne = @[@"最近一次结算金额", @"最近一次结算日期", @"结算状态"];
    NSArray *secListTwo = @[@[@"结算查询", @"tradesettleaccount.png", TradeSettleScopeViewController.class], @[@"银行结算账户", @"tradesettlesearch.png", TradeSettleBankAcctViewController.class]];
    NSArray *secListThree = @[@[@"即时结算", @"encashment.png", NSObject.class]];
    
    NSArray *templeList = @[secListOne, secListTwo, secListThree];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<list.count; i++) {
            PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
            if ([[list objectAtIndex:i] isKindOfClass:NSString.class]) {
                pc.titleSTR = [list objectAtIndex:i];
                pc.cellStyle = Cell_Style_Plain;
            }else if ([[list objectAtIndex:i] isKindOfClass:NSArray.class]){
                NSArray *array = [list objectAtIndex:i];
                pc.titleSTR = [array objectAtIndex:0];
                pc.imgNameSTR = [array objectAtIndex:1];
                pc.jumpClass = [array objectAtIndex:2];
                pc.cellStyle = Cell_Style_Standard;
                pc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            [secList addObject:pc];
        }
        [settleList addObject:secList];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"结算管理"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [self setUpSettleList];
    self.settleTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight) style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [settleTV setTableHeaderView:marginView];
    [settleTV setTableFooterView:marginView];
    [settleTV setBackgroundColor:[UIColor clearColor]];
    [settleTV setBackgroundView:nil];
    
    [settleTV setGeneralTableDataSource:settleList];
    [settleTV setDelegateViewController:self];
    
    [self.contentView addSubview:settleTV];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(self.isNeedRefresh)
    {
        self.isNeedRefresh = NO;
        [[AcquirerService sharedInstance].settleService onRespondTarget:self];
        [[AcquirerService sharedInstance].settleService requestForSettleManagement];
    }
    
}

-(void)processSettleMgtData:(NSDictionary *)body{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *dateFromSTR = [formatter dateFromString:[body objectForKey:@"lastBalDate"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *secListOne = [settleList objectAtIndex:0];
    ((PlainCellContent*)[secListOne objectAtIndex:0]).textSTR = [NSString stringWithFormat:@"%@元", [body objectForKey:@"lastBalAmt"]];
    ((PlainCellContent*)[secListOne objectAtIndex:1]).textSTR = [formatter stringFromDate:dateFromSTR];
    ((PlainCellContent*)[secListOne objectAtIndex:2]).textSTR = [[Acquirer sharedInstance] settleStatDesc:[body objectForKey:@"lastBalStat"]];
    
    [settleTV reloadData];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlainCellContent *content = [[settleList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (content.jumpClass && [content.jumpClass isSubclassOfClass:BaseViewController.class]) {
        BaseViewController *jpCTRL = [[[content.jumpClass alloc] init] autorelease];
        [self.navigationController pushViewController:jpCTRL animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        [[AcquirerService sharedInstance].encashService onRespondTarget:self];
        [[AcquirerService sharedInstance].encashService requestForBalanceAuth];
        
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000019"];
    }
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

-(void)jumpToViewController:(Class)CTRLClass{
    BaseViewController *CTRL = [[[CTRLClass alloc] init] autorelease];
    [self.navigationController pushViewController:CTRL animated:YES];
}

@end
