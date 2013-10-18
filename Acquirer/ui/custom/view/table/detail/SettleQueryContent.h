//
//  SettleQueryContent.h
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettleQueryContent : NSObject{
    NSString *accountIdSTR;
    NSString *balAmtSTR;
    NSString *balDateSTR;
    NSString *balSeqIdSTR;
    NSString *balStatSTR;
    NSString *cashChannelSTR;
}

@property (nonatomic, copy) NSString *accountIdSTR;
@property (nonatomic, copy) NSString *balAmtSTR;
@property (nonatomic, copy) NSString *balDateSTR;
@property (nonatomic, copy) NSString *balSeqIdSTR;
@property (nonatomic, copy) NSString *balStatSTR;
@property (nonatomic, copy) NSString *cashChannelSTR;

@end
