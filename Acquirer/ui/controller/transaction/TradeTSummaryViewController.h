//
//  TradeTodayGatherViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "PlainTableView.h"

@interface TradeTSummaryViewController : BaseViewController{
    PlainTableView *summaryTV;
    NSMutableArray *summaryList;
}

@property (nonatomic, retain) PlainTableView *summaryTV;
@property (nonatomic, readonly) NSMutableArray *summaryList;

-(void)refreshSummaryTableView;
-(void)processSummaryData:(NSDictionary *)dict;

@end
