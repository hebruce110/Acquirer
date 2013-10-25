//
//  GeneralTableView.m
//  Acquirer
//
//  Created by peer on 10/25/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "GeneralTableView.h"

@implementation GeneralTableView

-(void)dealloc{
    [generalDelegate release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        generalDelegate = [[GeneralTableDelegate alloc] init];
        self.delegate = generalDelegate;
        self.dataSource = generalDelegate;
    }
    return self;
}

//设置数据源
-(void)setGeneralTableDataSource:(NSMutableArray *)_List{
    generalDelegate.genList = _List;
}

//设置代理controller
-(void)setDelegateViewController:(BaseViewController *)baseCTRL{
    generalDelegate.CTRL = baseCTRL;
}

@end
