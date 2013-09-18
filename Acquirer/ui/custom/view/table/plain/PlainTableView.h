//
//  PlainTableView.h
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlainTableDelegate.h"

@interface PlainTableView : UITableView{
    //代理类
    PlainTableDelegate *delegatePT;
}


-(void)setPlainTableDataSource:(NSMutableArray *)formList;

@end
