//
//  TradeTDetailViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

typedef enum _TradeDetailType{
    TradeDetailToday = 1,
    TradeDetailHistory,
} TradeDetailType;

@interface TradeTDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    TradeDetailType tradeType;
    
    //历史刷卡明细的起始时间
    NSString *beginDateSTR;
    //历史刷卡明细的结束时间
    NSString *endDateSTR;
    
    UISegmentedControl *segControl;
    UITableView *detailTableView;
    
    NSMutableArray *tradeList;
    //重新发送标记
    NSString *resendFlag;
    
    BOOL isShowMore;
    UILabel *showMoreLabel;
    UIActivityIndicatorView *showMoreIndicator;
    
    ReqFlag reqFlagType;
    
    //是否要刷新TableView
    //从上个页面pop到当前页, 不做刷新操作
    BOOL needRefreshTableView;
}

@property (nonatomic, assign) TradeDetailType tradeType;

@property (nonatomic, copy) NSString *beginDateSTR;
@property (nonatomic, copy) NSString *endDateSTR;

@property (nonatomic, copy) NSString *resendFlag;
@property (nonatomic, retain) UISegmentedControl *segControl;
@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, retain) UILabel *showMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *showMoreIndicator;
@property (nonatomic, assign) BOOL needRefreshTableView;

-(void)refreshTodayTradeDetail;

-(void)processDetailData:(NSDictionary *)body;

@end
