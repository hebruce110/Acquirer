//
//  TradeEncashProtocalViewController.h
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface TradeEncashProtocalViewController : BaseViewController<UIScrollViewDelegate>{
    BOOL hasReadAll;
}

-(void)pressAgreeProtocal:(id)sender;

-(void)processProtocalEncashData:(NSDictionary *)dict;

@end
