//
//  User.h
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _UserState{
    //状态未知
    USER_STATE_UNKNOWN = 0,
    //待激活
    USER_STATE_WAIT_FOR_ACTIVATE,
    //已激活
    USER_STATE_ALREADY_ACTIVATED
}UserState;

@interface ACUser : NSObject{
    NSString *instSTR;
    NSString *opratorSTR;
    NSString *opratorNameSTR;
    NSString *passSTR;
    UserState state;
}

@property (nonatomic, copy) NSString *instSTR;
@property (nonatomic, copy) NSString *opratorSTR;
@property (nonatomic, copy) NSString *opratorNameSTR;
@property (nonatomic, copy) NSString *passSTR;
@property (nonatomic, assign) UserState state;

@end
