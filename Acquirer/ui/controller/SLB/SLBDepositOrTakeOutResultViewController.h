//
//  SLBDepositOrTakeOutResultViewController.h
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, SLBResultType)
{
    SLBResultDesposit,
    SLBResultTakeOut,
};

@interface SLBDepositOrTakeOutResultViewController : BaseViewController

@property (assign, nonatomic) CGFloat amountChanged;
@property (assign, nonatomic) SLBResultType resultType;

@end
