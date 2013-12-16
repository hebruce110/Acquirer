//
//  MessageNumberData.h
//  Acquirer
//
//  Created by soal on 13-11-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcquirerCPRequest.h"

@class ReportMessage;

//未读消息条目有变化(包括报表、通知)
#define DEF_MESSAGE_NUMBER_DID_CHANGED  @"DEF_MESSAGE_NUMBER_DID_CHANGED"

@interface MessageNumberData : NSObject

+ (MessageNumberData *)sharedData;

//根据type得到info
+ (ReportMessage *)reportByReportString:(NSString *)reportString;
+ (NSDictionary *)reportInfoByReportType:(NSString *)reportType;

//是否接收通知
+ (BOOL)receiveNotification;
//设定是否接收通知
+ (void)setReceiveNotification:(BOOL)receive;

//根据type得到是否需要购买
+ (BOOL)isNeedPayByReportType:(NSString *)reportType;
//改变type对应的购买状态
+ (void)setReportType:(NSString *)reportType isNeedPay:(BOOL)pay;

//根据type得到是否订阅
+ (BOOL)isSubScribedByReportType:(NSString *)reportType;
//改变type对应的订阅状态
+ (void)setReportType:(NSString *)reportType isSubScribed:(BOOL)subScribed;

//根据日期和type得到报表详情页的url
+ (NSURL *)reportDetailUrlByDateString:(NSString *)dateString act:(NSString *)act;

//聊天、报表、通知 日期
+ (NSDate *)messageLastUpdateDate;
+ (void)setMessageLastUpdateDate:(NSDate *)date;
+ (NSDate *)reportLastUpdateDate;
+ (void)setReportLastUpdateDate:(NSDate *)date;
+ (NSDate *)notificationLastUpdateDate;
+ (void)setNotificationLastUpdateDate:(NSDate *)date update:(BOOL)update;

//未读消息数量
+ (NSUInteger)messageCount;
//改变未读消息数量
+ (void)setMessageCount:(NSUInteger)count report:(BOOL)report;

//未读报表数量
+ (NSUInteger)reportCount;
//改变未读报表数量
+ (void)setReportCount:(NSUInteger)count report:(BOOL)report;

//改变未读公告数量
+ (void)setNotificationCount:(NSUInteger)count update:(BOOL)update;
//未读公告数量
+ (NSUInteger)notificationCount;

//更新报表类型信息
- (NSArray *)updateReportInfoList:(NSArray *)reportInfoList;

//更新报表未读列表
- (NSArray *)updateReportUnreadIdList:(NSArray *)reportUnreadIdList;

//网络请求查询报表回调
- (void)didUpdateMessages:(AcquirerCPRequest *)request;

//网络请求更新未读条数
- (void)updateReportUnreadCount:(NSInteger)unReadCount;

@end

//----------------------------
//报表信息
@interface ReportMessage : NSObject

@property (copy, nonatomic) NSString *typeString;
@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *month;

@end

