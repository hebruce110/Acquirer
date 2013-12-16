//
//  SLBService.h
//  Acquirer
//
//  Created by Soal on 13-10-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"
#import "SLBQueryService.h"
#import "SLBOpenService.h"
#import "SLBChangeAmountService.h"
#import "SLBDetailListService.h"
#import "SLBUser.h"

//生利宝的一些网络处理
@interface SLBService : BaseService

//生利宝用户
@property (retain, nonatomic, readonly) SLBUser *slbUser;

//生利宝查询
@property (retain, nonatomic, readonly) SLBQueryService *querySer;

//生利宝开户
@property (retain, nonatomic, readonly) SLBOpenService *openSer;

//生利宝存入、转出
@property (retain, nonatomic, readonly) SLBChangeAmountService *changeAmountSer;

//生利宝查询明细
@property (retain, nonatomic, readonly) SLBDetailListService *detailListSer;

//单例
+ (SLBService *)sharedService;

@end
