//
//  TradeSettleBankAcctViewController.m
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeSettleBankAcctViewController.h"
#import "PlainCellContent.h"

@implementation TradeSettleBankAcctViewController

@synthesize bankAcctTV;

-(void)dealloc{
    [bankAcctList release];
    [bankAcctTV release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        bankAcctList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"银行结算帐户"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    
    self.bankAcctTV = [[GeneralTableView alloc] initWithFrame:self.contentView.bounds
                                                    style:UITableViewStyleGrouped];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [bankAcctTV setTableHeaderView:marginView];
    [bankAcctTV setTableFooterView:marginView];
    [bankAcctTV setGeneralTableDataSource:bankAcctList];
    bankAcctTV.scrollEnabled = YES;
    bankAcctTV.backgroundColor = [UIColor clearColor];
    bankAcctTV.backgroundView = nil;
    [self.contentView addSubview:bankAcctTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [bankAcctList removeAllObjects];
    
    [[AcquirerService sharedInstance].settleService onRespondTarget:self];
    [[AcquirerService sharedInstance].settleService requestForBankSettleAccount];
}

-(void)processBankSettleAccountData:(NSDictionary *)dict{
    NSString *acctIdSTR = [dict objectForKey:@"acctId"];
    NSString *acctNameSTR = [dict objectForKey:@"acctName"];
    NSString *bankNameSTR = [dict objectForKey:@"bankName"];
    NSString *bankAddrSTR = [dict objectForKey:@"bankAddr"];
    NSString *branchNameSTR = [dict objectForKey:@"branchName"];
    
    NSArray *titleList = @[@"账号：", @"账户名：", @"账户银行：", @"开户地：", @"支行信息："];
    NSArray *textList = @[acctIdSTR, acctNameSTR, bankNameSTR, bankAddrSTR, branchNameSTR];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<titleList.count; i++) {
        PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
        pc.titleSTR = [titleList objectAtIndex:i];
        pc.textSTR = [textList objectAtIndex:i];
        pc.cellStyle = Cell_Style_Plain;
        [secOne addObject:pc];
    }
    [bankAcctList addObject:secOne];
    
    [self.bankAcctTV setGeneralTableDataSource:bankAcctList];
    [self.bankAcctTV reloadData];
}


@end
