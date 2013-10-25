//
//  GeneralTableView.h
//  Acquirer
//
//  Created by peer on 10/25/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralTableDelegate.h"

@class BaseViewController;

@interface GeneralTableView : UITableView{
    GeneralTableDelegate *generalDelegate;
}

//设置数据源
-(void)setGeneralTableDataSource:(NSMutableArray *)List;

//设置代理controller
-(void)setDelegateViewController:(BaseViewController *)baseCTRL;

@end
