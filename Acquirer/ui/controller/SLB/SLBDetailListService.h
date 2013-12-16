//
//  SLBDetailListService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SLBDetailListService : BaseService

//生利宝查询明细
- (void)requestForResend:(NSString *)resend target:(id)tg action:(SEL)action;

@end
