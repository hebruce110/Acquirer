//
//  SLBChangeAmountService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

typedef NS_OPTIONS(NSUInteger, SLBChangeType)
{
    SLBChangeIn,    //转入
    SLBChangeOut,   //转出
};

@interface SLBChangeAmountService : BaseService

//生利宝存入、转出
- (void)requestForServeNum:(NSString *)sernum changeType:(SLBChangeType)type changeAmt:(NSString *)amt target:(id)tg action:(SEL)action;

@end
