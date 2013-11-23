//
//  SLBQueryService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SLBQueryService : BaseService

//查询
- (void)requestForQueryTaget:(id)tg action:(SEL)action;

@end
