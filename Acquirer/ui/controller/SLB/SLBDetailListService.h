//
//  SLBDetailListService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SLBDetailListService : BaseService

//明细查询
- (void)requestForResend:(NSString *)resend taget:(id)tg action:(SEL)action;

@end
