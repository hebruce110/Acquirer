//
//  TradeSettleScopeViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class PlainTableView;

@interface TradeSettleScopeViewController : BaseViewController{
    PlainTableView *dateScopeTV;
    
    NSMutableArray *dsList;
}

@property (nonatomic, retain) PlainTableView *dateScopeTV;

@end
