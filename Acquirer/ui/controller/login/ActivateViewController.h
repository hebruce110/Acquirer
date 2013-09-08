//
//  ActivateViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivateViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>{
    UIScrollView *bgScrollView;
    UITableView *activateTableView;
    NSMutableArray *contentList;
    
    NSString *mobileSTR;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;
@property (nonatomic, retain) UITableView *activateTableView;
@property (nonatomic, copy) NSString *mobileSTR;

@end
