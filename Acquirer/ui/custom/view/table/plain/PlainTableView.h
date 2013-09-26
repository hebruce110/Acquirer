//
//  PlainTableView.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlainTableDelegate.h"

@class BaseViewController;

@interface PlainTableView : UITableView{
    //代理类
    PlainTableDelegate *delegatePT;
}
//设置数据源
-(void)setPlainTableDataSource:(NSMutableArray *)formList;
//设置代理controller
-(void)setDelegateViewController:(BaseViewController *)baseCTRL;

@end
