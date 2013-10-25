//
//  TradeSettleBankAcctViewController.h
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "GeneralTableView.h"

@interface TradeSettleBankAcctViewController : BaseViewController{
    NSMutableArray *bankAcctList;
    GeneralTableView *bankAcctTV;
}

@property (nonatomic, retain) GeneralTableView *bankAcctTV;

-(void)processBankSettleAccountData:(NSDictionary *)dict;

@end
