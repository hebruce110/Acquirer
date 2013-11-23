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
    //机构号
    NSString *instSTR;
    //操作员号
    NSString *opratorSTR;
    //密码
    NSString *passSTR;
    
    //操作员名字
    NSString *opratorNameSTR;
    
    //操作员预留手机号
    NSString *mobileSTR;
    
    //用户状态
    UserState state;
    
    //操作员的设备列表
    NSMutableArray *devList;
    
    //生利宝新加参数
    //最新收益率
    NSString *latestYield;
    //服务商开通生利宝权限标志位：Y／N
    NSString *agentSlbFlag;
    //生利宝帐户状态：正常－N，未开户－C
    NSString *acctStat;
}

@property (nonatomic, copy) NSString *instSTR;
@property (nonatomic, copy) NSString *opratorSTR;
@property (nonatomic, copy) NSString *passSTR;
@property (nonatomic, copy) NSString *opratorNameSTR;
@property (nonatomic, copy) NSString *mobileSTR;

@property (nonatomic, assign) UserState state;

@property (nonatomic, retain) NSMutableArray *devList;

@property (nonatomic, copy) NSString *latestYield;
@property (nonatomic, copy) id agentSlbFlag;
@property (nonatomic, copy) id acctStat;

-(void)deepCopyDevList:(NSArray *)list;

@end
