//
//  TransHomeViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface TradeHomeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *imageList;
    NSArray *titleList;
    
    UITableView *tradeTableView;
    
    NSArray *classList;
}

@property (nonatomic, retain) UITableView *tradeTableView;

@end
