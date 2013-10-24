//
//  TradeSettleViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class PlainTableView;

@interface TradeSettleMgtViewController : BaseViewController{
    NSMutableArray *settleList;
    PlainTableView *settleTV;
    
    //是否要刷新TableView
    //从上个页面pop到当前页, 不做刷新操作
    BOOL needRefreshTableView;
}

@property (nonatomic, retain) PlainTableView *settleTV;

-(void)processSettleMgtData:(NSDictionary *)body;
//处理即时结算返回数据
-(void)processEncashData:(NSDictionary *)dict;

//跳转到对应页面
-(void)jumpToViewController:(Class)CTRLClass;

@end
