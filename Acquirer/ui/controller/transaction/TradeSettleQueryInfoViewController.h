//
//  TradeSettleQueryInfoViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-10-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "SettleQueryContent.h"
#import "PlainTableView.h"

@interface TradeSettleQueryInfoViewController : BaseViewController{
    SettleQueryContent *sqContent;
    
    NSMutableArray *settleList;
    PlainTableView *settleTV;
}

@property (nonatomic, retain) SettleQueryContent *sqContent;

@property (nonatomic, retain) PlainTableView *settleTV;

-(void)processSettleQueryInfoData:(NSDictionary *)dict;

@end
