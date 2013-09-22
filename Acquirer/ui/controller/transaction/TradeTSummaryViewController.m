//
//  TradeTGatherViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTSummaryViewController.h"
#import "PlainTableView.h"
#import "PlainContent.h"

@implementation TradeTSummaryViewController

@synthesize summaryTV, summaryList;

-(void)dealloc{
    [summaryTV release];
    [summaryList release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        summaryList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpGatherList{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [summaryList removeAllObjects];
    
    NSArray *sectionOne = @[@"日期", @"今日总净额"];
    NSArray *sectionTwo = @[@"总消费金额", @"总消费笔数", @"总预授权完成金额", @"总预授权完成笔数"];
    NSArray *sectionThree = @[@"总消费撤销金额", @"总消费撤销笔数", @"总预授权完成撤销金额", @"总预授权完成撤销笔数", @"退货金额", @"退货笔数"];
    NSArray *templeList = @[sectionOne, sectionTwo, sectionThree];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *title in list) {
            PlainContent *pc = [[[PlainContent alloc] init] autorelease];
            pc.titleSTR = [NSString stringWithFormat:@"%@：", title];
            [secList addObject:pc];
        }
        [summaryList addObject:secList];
    }
    
    [pool drain];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"今日刷卡汇总"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [self setUpGatherList];

    self.summaryTV = [[[PlainTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)
                                                     style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [summaryTV setTableHeaderView:marginView];
    [summaryTV setTableFooterView:marginView];
    [summaryTV setPlainTableDataSource:self.summaryList];
    summaryTV.scrollEnabled = YES;
    summaryTV.backgroundColor = [UIColor clearColor];
    summaryTV.backgroundView = nil;
    [self.contentView addSubview:summaryTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *curDateSTR = [dateFormatter stringFromDate:[NSDate date]];
    
    [[AcquirerService sharedInstance].sumService requestForTradeSummay:Summary_Type_Today
                                                          withPnrDevId:@"00000000"
                                                              fromDate:curDateSTR
                                                                toDate:curDateSTR];
}

-(void)refreshSummaryTableView{
    [self.summaryTV reloadData];
}

//处理汇总数据
-(void)processSummaryData:(NSDictionary *)dict{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *sectionOne = [summaryList objectAtIndex:0];
    ((PlainContent *)[sectionOne objectAtIndex:0]).textSTR = [dateFormatter stringFromDate:[NSDate date]];
    ((PlainContent *)[sectionOne objectAtIndex:1]).textSTR = [dict objectForKey:@"totalNetAmt"];
    
    NSArray *sectionTwo = [summaryList objectAtIndex:1];
    ((PlainContent *)[sectionTwo objectAtIndex:0]).textSTR = [dict objectForKey:@"totalXpAmt"];
    ((PlainContent *)[sectionTwo objectAtIndex:1]).textSTR = [dict objectForKey:@"totalXpCnt"];
    ((PlainContent *)[sectionTwo objectAtIndex:2]).textSTR = [dict objectForKey:@"totalXwAmt"];
    ((PlainContent *)[sectionTwo objectAtIndex:3]).textSTR = [dict objectForKey:@"totalXwCnt"];
    
    NSArray *sectionThree = [summaryList objectAtIndex:2];
    ((PlainContent *)[sectionThree objectAtIndex:0]).textSTR = [dict objectForKey:@"totalXqAmt"];
    ((PlainContent *)[sectionThree objectAtIndex:1]).textSTR = [dict objectForKey:@"totalXqCnt"];
    ((PlainContent *)[sectionThree objectAtIndex:2]).textSTR = [dict objectForKey:@"totalXdAmt"];
    ((PlainContent *)[sectionThree objectAtIndex:3]).textSTR = [dict objectForKey:@"totalXdCnt"];
    ((PlainContent *)[sectionThree objectAtIndex:4]).textSTR = [dict objectForKey:@"totalXrAmt"];
    ((PlainContent *)[sectionThree objectAtIndex:5]).textSTR = [dict objectForKey:@"totalXrCnt"];
    
    [self refreshSummaryTableView];
}

@end
