//
//  DetailContent.h
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailContent : NSObject{
    NSString *orderIdSTR;
    NSString *bankCardSTR;
    NSString *tradeTimeSTR;
    NSString *tradeAmtSTR;
    NSString *tradeTypeSTR;
    NSString *tradeStatSTR;
}

@property (nonatomic, copy) NSString *orderIdSTR;
@property (nonatomic, copy) NSString *bankCardSTR;
@property (nonatomic, copy) NSString *tradeTimeSTR;
@property (nonatomic, copy) NSString *tradeAmtSTR;
@property (nonatomic, copy) NSString *tradeTypeSTR;
@property (nonatomic, copy) NSString *tradeStatSTR;

@end
