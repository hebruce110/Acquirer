//
//  MessageNumberData.m
//  Acquirer
//
//  Created by soal on 13-11-20.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "MessageNumberData.h"
#import "AcquirerService.h"
#import "Helper.h"
#import "SafeObject.h"
#import "AppDelegate.h"

//是否接收通知
#define DEF_RECEIVE_NOTIFICATION_KEY    @"DEF_RECEIVE_NOTIFICATION_KEY"

//未读消息数
#define DEF_MESSAGE_NUMBER_KEY          @"DEF_MESSAGE_NUMBER_KEY"

//未读报表数
#define DEF_REPORT_NUMBER_KEY           @"DEF_REPORT_NUMBER_KEY"

//未读公告数
#define DEF_NOTIFICATION_NUMBER_KEY     @"DEF_NOTIFICATION_NUMBER_KEY"

//报表种类信息
#define DEF_REPORT_INFO_LIST_KEY        @"DEF_REPORT_INFO_LIST_KEY"

//报表未读列表
#define DEF_REPORT_UNREAD_ID_LIST_KEY   @"DEF_REPORT_UNREAD_ID_LIST_KEY"

//最后一次更新消息的日期
#define DEF_MESSAGE_LAST_UPDATE_DATE    @"DEF_MESSAGE_LAST_UPDATE_DATE"

//最后一次更新报表的日期
#define DEF_REPORT_LAST_UPDATE_DATE     @"DEF_REPORT_LAST_UPDATE_DATE"

//最后一次更新通知的日期
#define DEF_NOTIFICATION_LAST_UPDATE_DATE @"DEF_NOTIFICATION_LAST_UPDATE_DATE"

@interface MessageNumberData ()

+ (void)saveReportInfoList:(NSArray *)reportInfoList;
+ (NSArray *)reportInfoList;

+ (void)saveReportList:(NSArray *)reportList;
+ (NSArray *)reportUnreadIdList;

@end


@implementation MessageNumberData

static MessageNumberData *data = nil;

+ (MessageNumberData *)sharedData
{
    @synchronized([self class])
    {
        if(data == nil) {
            data = [[MessageNumberData alloc] init];
        }
    }
    return (data);
}

//根据type得到info
+ (ReportMessage *)reportByReportString:(NSString *)reportString
{
    NSArray *cutArray = [reportString componentsSeparatedByString:@"|"];
    NSString *typeString = [cutArray safeObjectAtIndex:0];
    NSString *dateString = [cutArray safeObjectAtIndex:1];
    
    ReportMessage *rtMsg = [[ReportMessage alloc] init];
    rtMsg.typeString = typeString;
    rtMsg.dateString = dateString;
    
    if(typeString && [typeString isEqualToString:@"0106"]) {
        rtMsg.title = @"收入支出分析";
    }
    else if(typeString && [typeString isEqualToString:@"0107"]) {
        rtMsg.title = @"交易趋势分析";
    }
    
    if(dateString && dateString.length >= 6) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMM"];
        NSDate *date = [formatter dateFromString:dateString];
        
        [formatter setDateFormat:@"yyyy年"];
        NSString *year = [formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MM月"];
        NSString *month = [formatter stringFromDate:date];
        
        [formatter release];
        
        rtMsg.year = year;
        rtMsg.month = month;
    }
    
    return ([rtMsg autorelease]);
}

+ (NSDictionary *)reportInfoByReportType:(NSString *)reportType
{
    if(!reportType) {
        return (nil);
    }
    
    NSArray *infoList = [MessageNumberData reportInfoList];
    for(NSDictionary *dict in infoList) {
        NSString *tp = [dict safeJsonObjForKey:@"reportType"];
        if(tp && [tp isEqualToString:reportType]) {
            return (dict);
            
            break;
        }
    }
    
    return (nil);
}

//是否接收通知
+ (BOOL)receiveNotification
{
    NSNumber *rcNoti = [Helper getValueByKey:DEF_RECEIVE_NOTIFICATION_KEY];
    if(!rcNoti) {
        return (YES);
    }
    return ([rcNoti boolValue]);
}

//设定是否接收通知
+ (void)setReceiveNotification:(BOOL)receive
{
    AppDelegate *deg = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(deg && [deg respondsToSelector:@selector(setOpenReceivePushNotification:)]) {
        [deg setOpenReceivePushNotification:receive];
    }
    [Helper saveValue:[NSNumber numberWithBool:receive] forKey:DEF_RECEIVE_NOTIFICATION_KEY];
}

//根据type得到是否需要购买
+ (BOOL)isNeedPayByReportType:(NSString *)reportType
{
    NSDictionary *info = [MessageNumberData reportInfoByReportType:reportType];
    if(!info) {
        return (NO);
    }
    
    NSString *isPay = [info stringObjectForKey:@"isPay"];
    if(!(isPay && isPay.length > 0)) {
        return (NO);
    }
    
    if([isPay isEqualToString:@"Y"]) {
        return (YES);
    }
    
    return (NO);
}

//改变type对应的购买状态
+ (void)setReportType:(NSString *)reportType isNeedPay:(BOOL)pay
{
    if(reportType) {
        NSMutableDictionary *mtlInfo = nil;
        NSInteger ix = 0;
        NSArray *infoList = [MessageNumberData reportInfoList];
        for(ix = 0; ix < infoList.count; ix ++) {
            NSDictionary *dict = [infoList safeObjectAtIndex:ix];
            NSString *tp = [dict safeJsonObjForKey:@"reportType"];
            if(tp && [tp isEqualToString:reportType]) {
                mtlInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
                break;
            }
        }
        
        if(mtlInfo) {
            NSString *value = pay ? @"Y" : @"N";
            [mtlInfo setObject:value forKey:@"isPay"];
            
            NSMutableArray *mtlArray = [NSMutableArray arrayWithArray:infoList];
            [mtlArray replaceObjectAtIndex:ix withObject:mtlInfo];
            
            [data updateReportInfoList:mtlArray];
        }
    }
}

//根据type得到是否已经订阅
+ (BOOL)isSubScribedByReportType:(NSString *)reportType
{
    NSDictionary *info = [MessageNumberData reportInfoByReportType:reportType];
    if(!info) {
        return (NO);
    }
    
    NSString *isPay = [info stringObjectForKey:@"isSubscribe"];
    if(!(isPay && isPay.length > 0)) {
        return (NO);
    }
    
    if([isPay isEqualToString:@"Y"]) {
        return (YES);
    }
    
    return (NO);
}

//改变type对应的订阅状态
+ (void)setReportType:(NSString *)reportType isSubScribed:(BOOL)subScribed
{
    if(reportType) {
        NSMutableDictionary *mtlInfo = nil;
        NSInteger ix = 0;
        NSArray *infoList = [MessageNumberData reportInfoList];
        for(ix = 0; ix < infoList.count; ix ++) {
            NSDictionary *dict = [infoList safeObjectAtIndex:ix];
            NSString *tp = [dict safeJsonObjForKey:@"reportType"];
            if(tp && [tp isEqualToString:reportType]) {
                mtlInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
                break;
            }
        }
        
        if(mtlInfo) {
            NSString *value = subScribed ? @"Y" : @"N";
            [mtlInfo setObject:value forKey:@"isSubscribe"];
            
            NSMutableArray *mtlArray = [NSMutableArray arrayWithArray:infoList];
            [mtlArray replaceObjectAtIndex:ix withObject:mtlInfo];
            
            [data updateReportInfoList:mtlArray];
        }
    }
}

//根据日期和type得到报表详情页的url
+ (NSURL *)reportDetailUrlByDateString:(NSString *)dateString act:(NSString *)act
{
    NSMutableString *mtlString = [NSMutableString stringWithFormat:@"%@index.php?md5=", DEF_REPORT_URL];
    NSString *instString = [Acquirer sharedInstance].currentUser.instSTR;
    NSString *key = @"amazonamp021";

    NSString *mdResult = [Helper md5_16:[NSString stringWithFormat:@"%@%@%@", instString, dateString, key]];
    
    [mtlString appendFormat:@"%@&id=%@&act=%@&date=%@", mdResult, instString, act, dateString];
    
    return ([NSURL URLWithString:mtlString]);
}

//聊天、报表、通知 日期
+ (NSDate *)messageLastUpdateDate
{
    NSDate *date = [Helper getValueByKey:DEF_MESSAGE_LAST_UPDATE_DATE];
    if(!date) {
        return ([NSDate date]);
    }
    return (date);
}

+ (void)setMessageLastUpdateDate:(NSDate *)date
{
    if(date) {
        [Helper saveValue:date forKey:DEF_MESSAGE_LAST_UPDATE_DATE];
        
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
        }
    }
}

+ (NSDate *)reportLastUpdateDate
{
    NSDate *date = [Helper getValueByKey:DEF_REPORT_LAST_UPDATE_DATE];
    if(!date) {
        return ([NSDate date]);
    }
    return (date);
}

+ (void)setReportLastUpdateDate:(NSDate *)date
{
    if(date) {
        [Helper saveValue:date forKey:DEF_REPORT_LAST_UPDATE_DATE];
        
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
        }
    }
}

+ (NSDate *)notificationLastUpdateDate
{
    NSDate *date = [Helper getValueByKey:DEF_NOTIFICATION_LAST_UPDATE_DATE];
    if(!date) {
        return ([NSDate date]);
    }
    return (date);
}

+ (void)setNotificationLastUpdateDate:(NSDate *)date update:(BOOL)update
{
    if(date) {
        [Helper saveValue:date forKey:DEF_NOTIFICATION_LAST_UPDATE_DATE];
        
        if(update)
        {
            @autoreleasepool {
                [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
            }
        }
    }
}

//未读消息数量
+ (NSUInteger)messageCount
{
    NSNumber *number = [Helper getValueByKey:DEF_MESSAGE_NUMBER_KEY];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        return ([number unsignedIntegerValue]);
    }
    
    return (0);
}

//改变未读消息数量
+ (void)setMessageCount:(NSUInteger)count report:(BOOL)report
{
    [Helper saveValue:[NSNumber numberWithUnsignedInteger:count] forKey:DEF_MESSAGE_NUMBER_KEY];
    
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
    }
}

//未读报表数量
+ (NSUInteger)reportCount
{
    NSNumber *number = [Helper getValueByKey:DEF_REPORT_NUMBER_KEY];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        return ([number unsignedIntegerValue]);
    }
    
    return (0);
}

//改变未读报表数量
+ (void)setReportCount:(NSUInteger)count report:(BOOL)report
{
    if(report)
    {
        [data updateReportUnreadCount:count];
    }
    else {
        [Helper saveValue:[NSNumber numberWithUnsignedInteger:count] forKey:DEF_REPORT_NUMBER_KEY];
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
        }
    }
}

//未读公告数量
+ (NSUInteger)notificationCount
{
    NSNumber *number = [Helper getValueByKey:DEF_NOTIFICATION_NUMBER_KEY];
    if(number && [number isKindOfClass:[NSNumber class]]) {
        return ([number unsignedIntegerValue]);
    }
    
    return (0);
}

//改变未读公告数量
+ (void)setNotificationCount:(NSUInteger)count update:(BOOL)update
{
    [Helper saveValue:[NSNumber numberWithUnsignedInteger:count] forKey:DEF_NOTIFICATION_NUMBER_KEY];
    
    if(update)
    {
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
        }
    }
}

//-------------
//--- 保存 ---
//-------------
+ (void)saveReportInfoList:(NSArray *)reportInfoList
{
    if(reportInfoList) {
        [Helper saveValue:reportInfoList forKey:[MessageNumberData realSaveKeyBySuffix:DEF_REPORT_INFO_LIST_KEY]];
    }
}

+ (NSArray *)reportInfoList
{
    NSArray *infoList = [Helper getValueByKey:[MessageNumberData realSaveKeyBySuffix:DEF_REPORT_INFO_LIST_KEY]];
    return (infoList);
}

+ (void)saveReportList:(NSArray *)reportList
{
    if(reportList) {
        [Helper saveValue:[MessageNumberData sortReportList:reportList] forKey:[MessageNumberData realSaveKeyBySuffix:DEF_REPORT_UNREAD_ID_LIST_KEY]];
    }
}

+ (NSArray *)reportUnreadIdList
{
    NSArray *idList = [Helper getValueByKey:[MessageNumberData realSaveKeyBySuffix:DEF_REPORT_UNREAD_ID_LIST_KEY]];
    return (idList);
}

+ (NSString *)realSaveKeyBySuffix:(NSString *)suf
{
    ACUser *user = [Acquirer sharedInstance].currentUser;
    return ([NSString stringWithFormat:@"%@-%@-%@", user.instSTR, user.opratorSTR, suf]);
}

//------------
//--- 解析 ---
//------------
//排序
+ (NSArray *)sortReportList:(NSArray *)reportList
{
    if(!(reportList && reportList.count > 0)) {
        return (reportList);
    }
    
    NSArray *sortedList = [reportList sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *string1, NSString *string2){
        NSArray *cutArray1 = [string1 componentsSeparatedByString:@"|"];
        NSInteger type1 = [[cutArray1 safeObjectAtIndex:0] integerValue];
        NSInteger date1 = [[cutArray1 safeObjectAtIndex:1] integerValue];
        
        NSArray *cutArray2 = [string2 componentsSeparatedByString:@"|"];
        NSInteger type2 = [[cutArray2 safeObjectAtIndex:0] integerValue];
        NSInteger date2 = [[cutArray2 safeObjectAtIndex:1] integerValue];
        
        if(date1 > date2) {
            return (NSOrderedAscending);
        }
        
        if(date1 < date2) {
            return (NSOrderedDescending);
        }
        
        if(type1 > type2) {
            return (NSOrderedAscending);
        }
        
        if(type1 < type2) {
            return (NSOrderedDescending);
        }
        
        return (NSOrderedSame);
    }];
    
    return (sortedList);
}

//更新报表类型信息
- (NSArray *)updateReportInfoList:(NSArray *)reportInfoList
{
    if(!(reportInfoList && reportInfoList.count > 0)) {
        return ([MessageNumberData reportInfoList]);
    }
    
    if(!([MessageNumberData reportInfoList] && [MessageNumberData reportInfoList].count > 0)) {
        [MessageNumberData saveReportInfoList:reportInfoList];
        
        return (reportInfoList);
    }
    
    NSMutableArray *oldList = [NSMutableArray arrayWithArray:[MessageNumberData reportInfoList]];
    for(NSDictionary *info in reportInfoList) {
        NSString *reportType = [info stringObjectForKey:@"reportType"];
        if(reportType && reportType.length > 0) {
            BOOL needAdd = YES;
            for(NSInteger ix = 0; ix < oldList.count; ix ++) {
                NSDictionary *oldInfo = [oldList safeObjectAtIndex:ix];
                NSString *oldReportType = [oldInfo stringObjectForKey:@"reportType"];
                if([reportType isEqualToString:oldReportType]) {
                    needAdd = NO;
                    [oldList replaceObjectAtIndex:ix withObject:info];
                    break;
                }
            }
            if(needAdd) {
                [oldList addObject:info];
            }
        }
    }
    
    [MessageNumberData saveReportInfoList:oldList];
    
    return (oldList);
}

//更新报表未读列表
- (NSArray *)updateReportUnreadIdList:(NSArray *)reportUnreadIdList
{
    if(!(reportUnreadIdList && reportUnreadIdList > 0)) {
        return ([MessageNumberData reportUnreadIdList]);
    }
    
    if(!([MessageNumberData reportUnreadIdList] && [MessageNumberData reportUnreadIdList].count > 0)) {
        [MessageNumberData saveReportList:reportUnreadIdList];
        
        return ([MessageNumberData reportUnreadIdList]);
    }
    
    //添加
    NSMutableArray *oldUnreadList = [NSMutableArray arrayWithArray:[MessageNumberData reportUnreadIdList]];
    for(NSString *unread in reportUnreadIdList) {
        if(![oldUnreadList containsObject:unread]) {
            [oldUnreadList addObject:unread];
        }
    }
    
    [MessageNumberData saveReportList:oldUnreadList];
    
    return ([MessageNumberData reportUnreadIdList]);
}

//---------------
//--- 网络处理 ---
//---------------
//网络请求查询报表回调
- (void)didUpdateMessages:(AcquirerCPRequest *)request
{
    NSDictionary *resDict = (NSDictionary *)[request responseAsJson];
    
    NSArray *infoList = [resDict safeJsonObjForKey:@"infoList"];
    NSArray *unreadIdList = [resDict safeJsonObjForKey:@"unreadIdList"];
    NSString *lastUpdDateString = [resDict stringObjectForKey:@"lastUpdDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *lastUpDate = [formatter dateFromString:lastUpdDateString];
    [formatter release];
    
    
    [MessageNumberData setReportLastUpdateDate:lastUpDate];
    
    //未读数量
    [MessageNumberData setReportCount:unreadIdList.count report:NO];
    
    [self updateReportInfoList:infoList];
    [self updateReportUnreadIdList:unreadIdList];
}

#pragma mark - update unread count
//更新未读数量
- (void)updateReportUnreadCount:(NSInteger)unReadCount
{
    [[AcquirerService sharedInstance].onlineService requestUpdateReportInfoByFlag:@"1" reportType:@"" isSubscribe:@"" target:self action:@selector(didUpdateReportUnreadCount:)];
}

- (void)didUpdateReportUnreadCount:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    if(NotNilAndEqualsTo(body, @"isSucc", @"1")) {
        //现在的方案是清零
        [Helper saveValue:[NSNumber numberWithUnsignedInteger:0] forKey:DEF_REPORT_NUMBER_KEY];
        
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postNotificationName:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
        }
    }
}

@end

//----------------------------
//报表信息
@implementation ReportMessage

- (void)dealloc
{
    self.typeString = nil;
    self.dateString = nil;
    self.title = nil;
    self.year = nil;
    self.month = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.typeString = @"";
        self.dateString = @"";
        self.title = @"";
        self.year = @"";
        self.month = @"";
    }
    return (self);
}

@end
