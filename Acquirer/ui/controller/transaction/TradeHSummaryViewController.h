//
//  TradeHSummaryViewController.h
//  Acquirer
//
//  Created by peer on 10/29/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface TradeHSummaryViewController : BaseViewController{
    GeneralTableView *summaryTV;
    NSMutableArray *summaryList;
    
    NSString *devIdSTR;
    NSString *beginDateSTR;
    NSString *endDateSTR;
}

@property (nonatomic, retain) GeneralTableView *summaryTV;

@property (nonatomic, copy) NSString *devIdSTR;
@property (nonatomic, copy) NSString *beginDateSTR;
@property (nonatomic, copy) NSString *endDateSTR;

-(void)processSummaryData:(NSDictionary *)dict;

@end
