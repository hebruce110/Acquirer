//
//  TradeEncashConfirmViewController.h
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "GeneralTableView.h"

@interface ConfirmEncashModel : NSObject{
    //银行名称
    NSString *bankNameSTR;
    //银行帐户
    NSString *acctIdSTR;
    //取现金额
    NSString *cashAmtSTR;
    //手续费
    NSString *feeAmtSTR;
    //到账金额 到账金额=取现金额-手续费
    NSString *acctAmt;
}

@property (nonatomic, copy) NSString *bankNameSTR;
@property (nonatomic, copy) NSString *acctIdSTR;
@property (nonatomic, copy) NSString *cashAmtSTR;
@property (nonatomic, copy) NSString *feeAmtSTR;
@property (nonatomic, copy) NSString *acctAmt;

@end

@interface TradeEncashConfirmViewController : BaseViewController{
    ConfirmEncashModel *ceModel;
    
    NSMutableArray *encashList;
    
    GeneralTableView *encashTV;
}

@property (nonatomic, retain) ConfirmEncashModel *ceModel;
@property (nonatomic, retain) GeneralTableView *encashTV;

@end
