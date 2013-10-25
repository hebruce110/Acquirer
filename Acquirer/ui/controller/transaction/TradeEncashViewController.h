//
//  TradeEncashViewController.h
//  Acquirer
//
//  即时取现
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface EncashModel : NSObject{
    //商户可取款金额
    NSString *avlBalSTR;
    //当日取现额度
    NSString *cashAmtSTR;
    //商户最低取款金额
    NSString *miniAmtSTR;
    //到账银行
    NSString *bankNameSTR;
    //到账帐户
    NSString *acctIdSTR;
    //服务商全称
    NSString *agentNameSTR;
}

@property (nonatomic, copy) NSString *avlBalSTR;
@property (nonatomic, copy) NSString *cashAmtSTR;
@property (nonatomic, copy) NSString *miniAmtSTR;
@property (nonatomic, copy) NSString *bankNameSTR;
@property (nonatomic, copy) NSString *acctIdSTR;
@property (nonatomic, copy) NSString *agentNameSTR;

@end

@interface TradeEncashViewController : BaseViewController <UIGestureRecognizerDelegate>{
    EncashModel *ec;
    
    GeneralTableView *encashTV;
    NSMutableArray *encashList;
}

@property (nonatomic, retain) EncashModel *ec;
@property (nonatomic, retain) GeneralTableView *encashTV;

@end
