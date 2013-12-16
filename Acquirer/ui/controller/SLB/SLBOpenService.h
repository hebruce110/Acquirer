//
//  SLBOpenService.h
//  Acquirer
//
//  Created by Soal on 13-10-30.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface SLBOpenService : BaseService

//生利宝开户
- (void)requestForOpenTarget:(id)tg action:(SEL)action;

@end
