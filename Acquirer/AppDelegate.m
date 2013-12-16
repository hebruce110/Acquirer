//
//  AppDelegate.m
//  Acquirer
//
//  Created by chinaPnr on 13-8-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "AppDelegate.h"
#import "Acquirer.h"
#import "PostbeService.h"
#import "AcquirerService.h"
#import "ASIHTTPRequest.h"
#import "LoginViewController.h"
#import "TradeHomeViewController.h"
#import "HelpHomeViewController.h"
#import "OnlineServrMenuViewController.h"
#import "APService.h"
#import "MessageNumberData.h"
#import "SLBHelper.h"
#import "ChinaPnrNotificationViewController.h"
#import "ChinaPnrNotificationDetailViewController.h"


@interface AppDelegate ()

@property (retain, nonatomic) NSDictionary *launchOptions;

@end

@implementation AppDelegate

@synthesize loginNavi, transNavi, helpNavi, cpTabBar;

- (void)dealloc
{
    [_window release];
    
    [loginNavi release];
    [transNavi release];
    [helpNavi release];
    
    [naviArray release];
    [cpTabBar release];
    
    self.launchOptions = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        _launchOptions = nil;
    }
    return (self);
}

- (void)initializeUI{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginCTRL = [[[LoginViewController alloc] init] autorelease];
    loginNavi = [[CPNavigationController alloc] initWithRootViewController:loginCTRL];
    
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000014"];
    TradeHomeViewController *transCTRL = [[[TradeHomeViewController alloc] init] autorelease];
    transNavi = [[CPNavigationController alloc] initWithRootViewController:transCTRL];
    
    OnlineServrMenuViewController *onlineServrCTRL = [[[OnlineServrMenuViewController alloc] init] autorelease];
    helpNavi = [[CPNavigationController alloc] initWithRootViewController:onlineServrCTRL];
    
    naviArray = [[NSArray alloc] initWithObjects:transNavi,helpNavi, nil];
    
    self.window.rootViewController = loginNavi;
    
    [self.window makeKeyAndVisible];
}

//session超时
-(void)presentLoginViewControllerByCode:(NSString *)code
{
    static Boolean presentMessage = YES;
    
    if (presentMessage == YES) {
        
        if(!(code && code.length > 0))
        {
            code = @"02110";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[[Acquirer sharedInstance] codeCSVDesc:code]
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        
        presentMessage = NO;
        return;
    }
    
    //如果当前为login状态
    if ([Acquirer sharedInstance].logReason == LoginAlready) {
        [Acquirer sharedInstance].logReason = LoginSessionTimeOut;
        [self.window.rootViewController presentViewController:loginNavi animated:YES completion:^(void){ }];
    }
    presentMessage = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self presentLoginViewControllerByCode:nil];
}

//手动退出应用
-(void)manuallyLogout{
    [helpNavi popToRootViewControllerAnimated:NO];
    
    [Acquirer sharedInstance].logReason = LoginManuallyLogOut;
    self.window.rootViewController = loginNavi;
}

//第一次启动应用或手动点退出登录,  做　self.window.rootViewController = transNavi;
//其他情况:session超时,          做　dismissModalViewControllerAnimated
-(void) loginSucceed{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000018"];
    
    //请求报表数据
    [[AcquirerService sharedInstance].onlineService requestReportListTarget:[MessageNumberData sharedData] action:@selector(didUpdateMessages:)];
    
    //第一次启动应用或手动退出登录
    NSLog(@"%d", [Acquirer sharedInstance].logReason);
    if ([Acquirer sharedInstance].logReason == LoginAppLunchEachTime ||
        [Acquirer sharedInstance].logReason == LoginManuallyLogOut) {
        
        self.window.rootViewController = transNavi;
        
        //show loading view
        [self.window bringSubviewToFront:[Acquirer sharedInstance].uiPromptHUD];
        
        self.cpTabBar = [[[CPTabBar alloc] initWithFrame:CGRectMake(0, self.window.rootViewController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] autorelease];
        cpTabBar.delegate = self;
        [cpTabBar setTabSelected:0];
        [self.window.rootViewController.view addSubview:cpTabBar];
        
        //做code.csv版本检查工作
        [[AcquirerService sharedInstance].codeCSVService requestForCodeCSVVersion];
        
    }
    else if([Acquirer sharedInstance].logReason == LoginSessionTimeOut){
        [[Acquirer sharedInstance] hideUIPromptMessage:YES];
        
        [loginNavi dismissViewControllerAnimated:YES completion:^(void){}];
    }
    
    [Acquirer sharedInstance].logReason = LoginAlready;
    [loginNavi popToRootViewControllerAnimated:NO];
}

- (void)changeToIndex:(int)index
{
    CPNavigationController *cpNavi = [naviArray objectAtIndex:index];
    
    if (index != cpTabBar.index) {
        [cpTabBar removeFromSuperview];
        self.window.rootViewController = cpNavi;
        [self.window.rootViewController.view addSubview:cpTabBar];
        cpTabBar.index = index;
    }else{
        [cpNavi popToRootViewControllerAnimated:YES];
    }
    
    if(index == 1)
    {
        //统计码:00000038
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000038"];
    }
}

- (void)performApplicationStartUpLogic{
    [self initializeUI];
    
    [Acquirer initializeAcquirer];
    
    //请求UID
    //启动请求postbe
    if (![Helper stringNullOrEmpty:[Acquirer UID]]) {
        //启动客户端postbe
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000000"];
    }
    
    //检查版本更新
    [[AcquirerService sharedInstance].postbeService requestForVersionCheck];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    [self performApplicationStartUpLogic];
    
    self.openReceivePushNotification = [MessageNumberData receiveNotification];
    
    if(launchOptions && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        [self application:application didReceiveRemoteNotification:launchOptions];
        
        //点击系统通知栏进入应用
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000041"];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    
    [application cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSInteger num = application.applicationIconBadgeNumber;
    if(num > 0)
    {
        [self application:application hadPushNotificationCount:application.applicationIconBadgeNumber userInfo:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did fail to register for remote notifications with error:%@", error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    
    [self application:application hadPushNotificationCount:1 userInfo:userInfo];
}

#pragma mark -
- (void)setOpenReceivePushNotification:(BOOL)openReceivePushNotification
{
    _openReceivePushNotification = openReceivePushNotification;
    if(_openReceivePushNotification)
    {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        [APService setupWithOption:_launchOptions];
    }
    else
    {
        [APService registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone];
        [APService setupWithOption:_launchOptions];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application hadPushNotificationCount:(NSInteger)count userInfo:(NSDictionary *)userInfo
{
    count += [MessageNumberData notificationCount];

    //如果当前在公告列表或者公告详情页，则此时收到通知不更新UI
    BOOL update = !(cpTabBar.index == 1
                &&  helpNavi.topViewController
                && ([helpNavi.topViewController isKindOfClass:[ChinaPnrNotificationViewController class]]
                    || [helpNavi.topViewController isKindOfClass:[ChinaPnrNotificationDetailViewController class]]));
    
    [MessageNumberData setNotificationCount:(count * update) update:update];
    
    if(NotNilAndEqualsTo(userInfo, @"content_type", @"0"))
    {
        NSLog(@"--->userInfo:%@", userInfo);
        if(NotNil(userInfo, @"date"))
        {
            NSString *dateString = [userInfo objectForKey:@"date"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            if([NSString string:@"年" isRangeOfString:dateString]) {
                [formatter setDateFormat:@"yyyy年MM月dd日"];
            }
            else {
                [formatter setDateFormat:@"MM月dd日"];
            }
            
            NSDate *date = [formatter dateFromString:dateString];
            [formatter release];
            [MessageNumberData setNotificationLastUpdateDate:date update:update];
        }
    }
}

@end
