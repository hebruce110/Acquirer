//
//  TradeTDetailInfoViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTDetailInfoViewController.h"
#import "PlainTableView.h"

@implementation TradeTDetailInfoViewController

@synthesize tradeInfoTV;

-(void)dealloc{
    [tradeInfoTV release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"刷卡详情"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    //[self setUpSummaryList];
    
    self.tradeInfoTV = [[[PlainTableView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)
                                                      style:UITableViewStyleGrouped] autorelease];
    UIView *marginView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 10)] autorelease];
    [marginView setBackgroundColor:[UIColor clearColor]];
    [tradeInfoTV setTableHeaderView:marginView];
    [tradeInfoTV setTableFooterView:marginView];
    [tradeInfoTV setPlainTableDataSource:self.summaryList];
    tradeInfoTV.scrollEnabled = YES;
    tradeInfoTV.backgroundColor = [UIColor clearColor];
    tradeInfoTV.backgroundView = nil;
    [self.contentView addSubview:tradeInfoTV];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}




@end
