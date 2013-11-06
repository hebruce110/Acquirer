//
//  TradeEncashResultViewController.h
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "EncashRes.h"

@interface TradeEncashResultViewController : BaseViewController{
    EncashRes encashRes;
    NSString *bankIdSTR;
}

@property (nonatomic, assign) EncashRes encashRes;
@property (nonatomic, copy) NSString *bankIdSTR;


@end
