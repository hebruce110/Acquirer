//
//  NoticeService.h
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

typedef NS_OPTIONS (NSInteger, MessageFlag){
    messageUnknow = 0,          //未知
    messageNotice = 1,          //公告
    messageNotificatin = 2,     //个人通知
    
    messageLeaveMsg,            //留言
};//视图类型的标记

typedef NS_OPTIONS(NSInteger, messageReportFlag){
    messageReportUnknow = -1,       //未知
    messageReportNotification = 0,  //通知
    messageReportNotice = 1,        //公告
};//网络请求的标记

@interface NoticeService : BaseService

//公告、通知查询
- (void)requestNoticeListByResend:(NSString *)resend flag:(MessageFlag)flag reportFlag:(messageReportFlag)reportFlag Target:(id)tg action:(SEL)action;

//公告、通知详情查询
- (void)requestNoticeDetailByFlag:(MessageFlag)flag noticeId:(NSString *)noticeId Target:(id)tg action:(SEL)action;

//留言信息查询
- (void)requestLeaveMessageByResend:(NSString *)resend Target:(id)tg action:(SEL)action;

//留言信息详情
- (void)requestLeaveMessageDetailByMsgId:(NSString *)msgId Target:(id)tg action:(SEL)action;

//留言信息新增
- (void)requestAddLeaveMessageByTitle:(NSString *)title content:(NSString *)content Target:(id)tg action:(SEL)action;

@end
