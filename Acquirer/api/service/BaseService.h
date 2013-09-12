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

@end
