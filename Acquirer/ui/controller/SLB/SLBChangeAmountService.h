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

//转入、转出
- (void)requestForServeNum:(NSString *)sernum changeType:(SLBChangeType)type changeAmt:(CGFloat)amt taget:(id)tg action:(SEL)action;

@end
