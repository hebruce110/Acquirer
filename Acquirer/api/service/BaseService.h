//
//  BasicService.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"
#import "NSNotificationCenter+CP.h"
#import "AcquirerCPRequest.h"
#import "Acquirer.h"
#import "DeviceIntrospection.h"

//添加可选的请求信息，包括每次请求都要传递的参数
/*
    operTime | 客户端操作时间
    uid  | 手机客户端标示
    version |  版本号
    ip  |   访问服务端的ip地址
    checkValue  |   预留字符
 */
void AddOptionalReqInfomation(NSMutableDictionary *dict);

@interface BaseService : NSObject{
    id target;
    SEL selector;
}

- (id)onRespondTarget:(id)_target;
- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

- (void) requestFailed:(AcquirerCPRequest *)req;
- (void) requestTimeOut:(AcquirerCPRequest *)req;

-(void) processMTPRespCode:(AcquirerCPRequest *)req;
//- (void) processMTPRespDesc:(PosMiniCPRequest *)req;
/*
 返回当前操作时间
 */
-(NSString *)oprateTime;

/*
 格式化为YYYYMMDD格式
 */
-(NSString *)formatAsYMD:(NSDate *) date;

@end
