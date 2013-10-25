//
//  TradeSettleQueryInfoViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "SettleQueryContent.h"
#import "GeneralTableView.h"

@interface TradeSettleQueryInfoViewController : BaseViewController{
    SettleQueryContent *sqContent;
    
    NSMutableArray *settleList;
    GeneralTableView *settleTV;
}

@property (nonatomic, retain) SettleQueryContent *sqContent;

@property (nonatomic, retain) GeneralTableView *settleTV;

-(void)processSettleQueryInfoData:(NSDictionary *)dict;

@end
