//
//  TradeTDetailInfoViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTDetailInfoViewController.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"

@implementation TradeTDetailInfoViewController

@synthesize orderIdSTR;
@synthesize tradeInfoTV;

-(void)dealloc{
    [tradeInfoTV release];
    [tradeDList release];
    
    [orderIdSTR release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        self.isNeedRefresh = YES;
        tradeDList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpDetailList{
    NSArray *secListOne = @[@"卡号：",@"终端号：", @"订单号：", @"交易时间：", @"交易金额：", @"交易类型：", @"交易状态：", @"温馨提示："];
    NSArray *secListTwo = @[@"批次号：", @"凭证号：", @"授权号：", @"参考号："];
    NSArray *templeList = @[secListOne, secListTwo];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *title in list) {
            PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
            pc.titleSTR = title;
            [secList addObject:pc];
        }
        [tradeDList addObject:secList];
    }
    ((PlainCellContent *)((NSArray *)[tradeDList objectAtIndex:0]).lastObject).cellStyle = Cell_Style_LineBreak;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"刷卡详情"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [self setUpDetailList];
    
    self.tradeInfoTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)
                                                      style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [tradeInfoTV setTableHeaderView:marginView];
    [tradeInfoTV setTableFooterView:marginView];
    [tradeInfoTV setGeneralTableDataSource:tradeDList];
    tradeInfoTV.scrollEnabled = YES;
    tradeInfoTV.backgroundColor = [UIColor clearColor];
    tradeInfoTV.backgroundView = nil;
    [self.contentView addSubview:tradeInfoTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.isNeedRefresh)
    {
        self.isNeedRefresh = NO;
    [[AcquirerService sharedInstance].detailService onRespondTarget:self];
    [[AcquirerService sharedInstance].detailService requestForTradeDetailInfo:orderIdSTR];
    }
}

-(void)processDetailData:(NSDictionary *)body
{
    NSString *tradeTime = [body objectForKey:@"transTime"];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *tradeDate = [formatter dateFromString:tradeTime];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *remarkString = nil;
    if (NotNil(body, @"remarks") && ![[body objectForKey:@"remarks"] isEqualToString:@"<null>"]) {
        remarkString = [[Acquirer sharedInstance] codeCSVDesc:[body objectForKey:@"remarks"]];
    }
    else
    {
        remarkString = @"详细原因请联系当地服务商";
    }
    
    NSArray *sectionOne = [tradeDList objectAtIndex:0];
    ((PlainCellContent *)[sectionOne objectAtIndex:0]).textSTR = [body objectForKey:@"cardNo"];
    ((PlainCellContent *)[sectionOne objectAtIndex:1]).textSTR = [body objectForKey:@"pnrDevId"];
    ((PlainCellContent *)[sectionOne objectAtIndex:2]).textSTR = [body objectForKey:@"ordId"];
    ((PlainCellContent *)[sectionOne objectAtIndex:3]).textSTR = [formatter stringFromDate:tradeDate];
    ((PlainCellContent *)[sectionOne objectAtIndex:4]).textSTR = [NSString stringWithFormat:@"%@元", [body objectForKey:@"amt"]];
    ((PlainCellContent *)[sectionOne objectAtIndex:5]).textSTR = [[Acquirer sharedInstance] tradeTypeDesc:[body objectForKey:@"transType"]];
    ((PlainCellContent *)[sectionOne objectAtIndex:6]).textSTR = [[Acquirer sharedInstance] tradeStatDesc:[body objectForKey:@"transStat"]];
    ((PlainCellContent *)[sectionOne objectAtIndex:7]).textSTR = remarkString;
    
    NSArray *sectionTwo = [tradeDList objectAtIndex:1];
    ((PlainCellContent *)[sectionTwo objectAtIndex:0]).textSTR = [body objectForKey:@"batchId"];
    ((PlainCellContent *)[sectionTwo objectAtIndex:1]).textSTR = [body objectForKey:@"posSeqId"];
    ((PlainCellContent *)[sectionTwo objectAtIndex:2]).textSTR = [body objectForKey:@"authCode"];
    ((PlainCellContent *)[sectionTwo objectAtIndex:3]).textSTR = [body objectForKey:@"refNum"];
    
    [self.tradeInfoTV reloadData];
}

@end
