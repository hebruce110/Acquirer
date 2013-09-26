//
//  TradeTDetailInfoViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "PlainTableView.h"

@interface TradeTDetailInfoViewController : BaseViewController{
    PlainTableView *tradeInfoTV;
    NSMutableArray *tradeDList;
    
    NSString *orderIdSTR;
}

@property (nonatomic, retain) PlainTableView *tradeInfoTV;
@property (nonatomic, copy) NSString *orderIdSTR;

-(void)processDetailData:(NSDictionary *)body;

@end
