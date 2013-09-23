//
//  TradeTDetailViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface TradeTDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    UISegmentedControl *segControl;
    UITableView *detailTableView;
}

@property (nonatomic, retain) UISegmentedControl *segControl;
@property (nonatomic, retain) UITableView *detailTableView;

@end
