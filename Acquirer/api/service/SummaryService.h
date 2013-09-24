//
//  SummaryService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-22.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

//汇总类型，今日汇总｜历史汇总
typedef enum _SummaryType{
    Summary_Type_History = 0,
    Summary_Type_Today,
} SummaryType;

@interface SummaryService : BaseService

-(void)requestForTradeSummay:(SummaryType) sumType withPnrDevId:(NSString *)devIdSTR
                    fromDate:(NSString *)fdate toDate:(NSString *)tdate;

@end
