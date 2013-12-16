//
//  AppDelegate.h
//  Acquirer
//
//  Created by chinaPnr on 13-8-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPNavigationController.h"
#import "CPTabBarDelegate.h"
#import "CPTabBar.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CPTabBarDelegate, UIAlertViewDelegate>{
    CPNavigationController *loginNavi;
    CPNavigationController *transNavi;
    CPNavigationController *helpNavi;
    
    NSArray *naviArray;
    
    CPTabBar *cpTabBar;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) CPNavigationController *loginNavi;
@property (readonly, nonatomic) CPNavigationController *transNavi;
@property (readonly, nonatomic) CPNavigationController *helpNavi;
@property (retain, nonatomic) CPTabBar *cpTabBar;

//打开或关闭接收通知
@property (assign, nonatomic) BOOL openReceivePushNotification;

-(void)presentLoginViewControllerByCode:(NSString *)code;

-(void)manuallyLogout;
-(void)loginSucceed;

@end
