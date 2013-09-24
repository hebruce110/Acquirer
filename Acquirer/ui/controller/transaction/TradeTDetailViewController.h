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
}

@property (nonatomic, copy) NSString *resendFlag;
@property (nonatomic, retain) UISegmentedControl *segControl;
@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, retain) UILabel *showMoreLabel;
@property (nonatomic, retain) UIActivityIndicatorView *showMoreIndicator;

-(void)processDetailData:(NSDictionary *)body;

@end
