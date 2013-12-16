//
//  SLBQueryService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SLBQueryService : BaseService

//生利宝查询
- (void)requestForQueryTarget:(id)tg action:(SEL)action;

@end
