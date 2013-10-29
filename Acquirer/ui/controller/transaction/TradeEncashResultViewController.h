//
//  TradeEncashResultViewController.h
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

typedef enum _EncashRes{
    //取现成功
    EncashSuccess = 0,
    //取现失败
    EncashFailure,
    //处理中
    EncashPending
} EncashRes;

@interface TradeEncashResultViewController : BaseViewController{
    EncashRes encashRes;
    NSString *bankIdSTR;
}

@property (nonatomic, assign) EncashRes encashRes;
@property (nonatomic, copy) NSString *bankIdSTR;


@end
