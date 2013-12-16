//
//  TradeSettleViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface TradeSettleMgtViewController : BaseViewController{
    NSMutableArray *settleList;
    GeneralTableView *settleTV;
}

@property (nonatomic, retain) GeneralTableView *settleTV;

-(void)processSettleMgtData:(NSDictionary *)body;
//处理即时结算返回数据
-(void)processEncashData:(NSDictionary *)dict;

//跳转到对应页面
-(void)jumpToViewController:(Class)CTRLClass;

@end
