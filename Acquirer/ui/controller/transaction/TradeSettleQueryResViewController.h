//
//  TradeSettleQueryResViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface TradeSettleQueryResViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>{
    UITableView *sqTableView;
    
    NSString *startDateSTR;
    NSString *endDateSTR;
    
    //重新发送标记
    NSString *resendFlag;
    
    //是否要刷新TableView
    //从上个页面pop到当前页, 不做刷新操作
    BOOL needRefreshTableView;
}

@property (nonatomic, retain) UITableView *sqTableView;
@property (nonatomic, retain) NSString *resendFlag;

-(id)initWithStartDate:(NSString *)startSTR endDate:(NSString *)endSTR;

-(void)processSettleQueryData:(NSDictionary *)body;

@end
