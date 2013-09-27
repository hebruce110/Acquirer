//
//  Acquirer.h
//  Acquirer
//
//  Created by chinapnr on 13-8-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "ACUser.h"

@class ASIHTTPRequest;

typedef enum _AcquirerLoginReason {
    //session超时
    LoginSessionTimeOut = 0,
    //每次启动应用
    LoginAppLunchEachTime,
    //用户手动点击退出
    LoginManuallyLogOut
} AcquirerLoginReason;

@interface Acquirer : NSObject <MBProgressHUDDelegate>{
    MBProgressHUD *uiPromptHUD;
    MBProgressHUD *sysPromptHUD;
    
    NSDictionary *codedescMap;
    
    ACUser *currentUser;
    
    //配置文件code.csv版本号
    int codeCSVVersion;
    NSMutableArray *codeList;
    
    NSString *uidSTR;
    
    //交易类型
    NSDictionary *tradeTypeDict;
    //交易状态
    NSDictionary *tradeStatDict;
    //结算状态
    NSDictionary *settleStatDict;
    
    //到登录页面的原因
    AcquirerLoginReason logReason;
}

@property (nonatomic, retain) MBProgressHUD *uiPromptHUD;
@property (nonatomic, retain) MBProgressHUD *sysPromptHUD;

@property (nonatomic, readonly) NSDictionary *codedescMap;

@property (nonatomic, retain) ACUser *currentUser;

@property (nonatomic, assign) int codeCSVVersion;

@property (nonatomic, copy) NSString *uidSTR;

@property (nonatomic, assign) AcquirerLoginReason logReason;

+(Acquirer *)sharedInstance;
+(void)destroySharedInstance;
+(void)initializeAcquirer;
+(void)shutdown;

+(NSString *)bundleVersion;
+(NSString *)UID;

//check is production environment
+(BOOL)isProductionEnvironment;

-(void) showUIPromptMessage:(NSString *)message animated:(BOOL)animated;
-(void) hideUIPromptMessage:(BOOL)animated;

-(void) displayUIPromptAutomatically:(NSNotification *)notification;
-(void) displaySysPromptAutomatically:(NSNotification *)notification;

-(void)performRequest:(ASIHTTPRequest *)req;

//用户登录
- (void)presentLoginViewController:(NSNotification *)notification;

//初始化code.csv版本
-(void)initCodeCSVVersion;

//拷贝code.csv配置文件到Documents目录
-(void)copyConfigFileToDocuments;

//解析MTP服务端返回码对应的描述文字
-(void)parseReturnCodeDescFile;

//解析服务端下载的code.csv文件
-(void)parseCodeCSVFile;

//状态码描述
-(NSString *)respDesc:(NSString *)codeSTR;
//交易类型描述
-(NSString *)tradeTypeDesc:(NSString *)tradeTypeCode;
//交易状态描述
-(NSString *)tradeStatDesc:(NSString *)tradeStatCode;
//交易结算状态描述
-(NSString *)settleStatDesc:(NSString *)settleStatCode;
//code.csv状态码描述
-(NSString *)codeCSVDesc:(NSString *)codeSTR;

@end


@interface CodeInfo : NSObject{
    //codeType分三种　刷卡返回码｜刷卡详情失败原因｜结算失败原因
    NSString *codeTypeSTR;
    NSString *codeNumSTR;
    NSString *codeDesc;
}

@property (nonatomic, copy) NSString *codeTypeSTR;
@property (nonatomic, copy) NSString *codeNumSTR;
@property (nonatomic, copy) NSString *codeDesc;

@end

