//
//  TradeTodayGatherViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "GeneralTableView.h"

@interface TradeTSummaryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    GeneralTableView *summaryTV;
    NSMutableArray *summaryList;
}

@property (nonatomic, retain) GeneralTableView *summaryTV;
@property (nonatomic, readonly) NSMutableArray *summaryList;

-(void)processSummaryData:(NSDictionary *)dict;

@end
