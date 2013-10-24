//
//  TradeSettleBankAcctViewController.h
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "PlainTableView.h"

@interface TradeSettleBankAcctViewController : BaseViewController{
    NSMutableArray *bankAcctList;
    PlainTableView *bankAcctTV;
}

@property (nonatomic, retain) PlainTableView *bankAcctTV;

-(void)processBankSettleAccountData:(NSDictionary *)dict;

@end
