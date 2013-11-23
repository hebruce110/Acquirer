//
//  TransHomeViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface TradeHomeViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tradeTableView;
    NSArray *imageList;
    NSArray *titleList;
    NSArray *classList;
}

@property (retain, nonatomic) UITableView *tradeTableView;

@end
