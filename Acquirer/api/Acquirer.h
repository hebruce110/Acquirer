//
//  Acquirer.h
//  Acquirer
//
//  Created by chinapnr on 13-8-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@class ASIHTTPRequest;

@interface Acquirer : NSObject <MBProgressHUDDelegate>{
    MBProgressHUD *uiPromptHUD;
    MBProgressHUD *sysPromptHUD;
}

@property (nonatomic, retain) MBProgressHUD *uiPromptHUD;
@property (nonatomic, retain) MBProgressHUD *sysPromptHUD;

+(Acquirer *)sharedInstance;
+(void)destroySharedInstance;
+(void)initializeAcquirer;
+(void)shutdown;
+(NSString *)bundleVersion;

//check is production environment
+(BOOL)isProductionEnvironment;

-(void) showUIPromptMessage:(NSString *)message animated:(BOOL)animated;
-(void) hideUIPromptMessage:(BOOL)animated;

-(void) displayUIPromptAutomatically:(NSNotification *)notification;
-(void) displaySysPromptAutomatically:(NSNotification *)notification;

-(void)performRequest:(ASIHTTPRequest *)req;

//用户登录
- (void)presentLoginViewController:(NSNotification *)notification;

//拷贝code.csv配置文件到Documents目录
-(void)copyConfigFileToDocuments;

@end







































