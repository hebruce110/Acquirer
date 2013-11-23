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

@interface SLBService : BaseService
{
    SLBUser *_slbUser;
    
    SLBQueryService *_querySer;
    SLBOpenService *_openSer;
    SLBChangeAmountService *_changeAmountSer;
    SLBDetailListService *_detailListSer;
}
@property (retain, nonatomic) SLBUser *slbUser;

@property (retain, nonatomic) SLBQueryService *querySer;
@property (retain, nonatomic) SLBOpenService *openSer;
@property (retain, nonatomic) SLBChangeAmountService *changeAmountSer;
@property (retain, nonatomic) SLBDetailListService *detailListSer;

//单例
+ (SLBService *)sharedService;


@end
