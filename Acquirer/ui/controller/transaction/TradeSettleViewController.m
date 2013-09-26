//
//  TradeSettleViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleViewController.h"
#import "PlainTableView.h"
#import "PlainContent.h"

@implementation TradeSettleViewController

-(void)dealloc{
    [settleList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        settleList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpSettleList{
    NSArray *secListOne = @[@"最近一次结算金额", @"最近一次结算日期", @"结算状态"];
    NSArray *secListTwo = @[@[@"结算查询", @"tradesettleaccount.png"], @[@"银行结算账户", @"tradesettlesearch.png"]];
    NSArray *templeList = @[secListOne, secListTwo];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<list.count; i++) {
            PlainContent *pc = [[[PlainContent alloc] init] autorelease];
            if ([[list objectAtIndex:i] isKindOfClass:NSString.class]) {
                pc.titleSTR = [list objectAtIndex:i];
                pc.cellStyle = Cell_Style_Plain;
            }else if ([[list objectAtIndex:i] isKindOfClass:NSArray.class]){
                NSArray *array = [list objectAtIndex:i];
                pc.titleSTR = [array objectAtIndex:0];
                pc.imgNameSTR = [array objectAtIndex:1];
                pc.cellStyle = Cell_Style_Standard;
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
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [self setUpSettleList];
    PlainTableView *settleTV = [[PlainTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 280) style:UITableViewStyleGrouped];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [settleTV setTableHeaderView:marginView];
    [settleTV setTableFooterView:marginView];
    [settleTV setBackgroundColor:[UIColor clearColor]];
    [settleTV setBackgroundView:nil];
    
    //settleTV.scrollEnabled = NO;
    [settleTV setPlainTableDataSource:settleList];
    [settleTV setDelegateViewController:self];
    [self.contentView addSubview:settleTV];
    
    
}

@end
