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
    
    //SettleQueryList
    NSMutableArray *sqList;
    
    NSString *startDateSTR;
    NSString *endDateSTR;
    
    //显示更多
    BOOL isShowMore;
    UILabel *showMoreLabel;
    UIActivityIndicatorView *showMoreIndicator;
    
    //重新发送标记
    NSString *resendFlag;
}

@property (nonatomic, retain) UITableView *sqTableView;
@property (nonatomic, retain) NSString *resendFlag;
@property (nonatomic, retain) UILabel *showMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *showMoreIndicator;

-(id)initWithStartDate:(NSString *)startSTR endDate:(NSString *)endSTR;

-(void)processSettleQueryData:(NSDictionary *)body;

@end
