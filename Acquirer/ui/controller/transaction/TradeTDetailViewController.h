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

@property (nonatomic, copy) NSString *resendFlag;
@property (nonatomic, retain) UISegmentedControl *segControl;
@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, retain) UILabel *showMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *showMoreIndicator;
@property (nonatomic, assign) BOOL needRefreshTableView;

-(void)refreshTodayTradeDetail;

-(void)processDetailData:(NSDictionary *)body;

@end
