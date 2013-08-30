//
//  BasicService.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSNotificationCenter+CP.h"

@interface BasicService : NSObject{
    id target;
    SEL selector;
}

- (id)onRespondTarget:(id)_target;
- (id)onRespondTarget:(id)_target selector:(SEL)_selector;

- (void) requestFailed:(ASIHTTPRequest *)req;
- (void) requestTimeOut:(ASIHTTPRequest *)req;

//- (void) processMTPRespDesc:(PosMiniCPRequest *)req;

@end
