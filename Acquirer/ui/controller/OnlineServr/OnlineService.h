//
//  OnlineService.h
//  Acquirer
//
//  Created by soal on 13-11-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface OnlineService : BaseService

//报表信息查询
- (void)requestReportListTarget:(id)tg action:(SEL)action;

//报表信息更新接口
- (void)requestUpdateReportInfoByFlag:(NSString *)flag reportType:(NSString *)reportType isSubscribe:(NSString *)isSubscribe target:(id)tg action:(SEL)action;

@end
