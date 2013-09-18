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

#import "LoginViewController.h"
#import "TransHomeViewController.h"
#import "HelpHomeViewController.h"

#import "TestViewController.h"

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
    
    [super dealloc];
}

- (void)initializeUI{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginCTRL = [[LoginViewController alloc] init];
    loginNavi = [[CPNavigationController alloc] initWithRootViewController:loginCTRL];
    
    TransHomeViewController *transCTRL = [[[TransHomeViewController alloc] init] autorelease];
    transNavi = [[CPNavigationController alloc] initWithRootViewController:transCTRL];
    
    HelpHomeViewController *helpCTRL = [[[HelpHomeViewController alloc] init] autorelease];
    helpNavi = [[CPNavigationController alloc] initWithRootViewController:helpCTRL];
    
    naviArray = [[NSArray alloc] initWithObjects:transNavi,helpNavi, nil];
    
    self.window.rootViewController = loginNavi;
    
    [self.window makeKeyAndVisible];
}

//只有第一次启动应用，用户完成登录，做　self.window.rootViewController = transNavi;
//其他情况：session超时或手动点击登出，做　dismissModalViewControllerAnimated
-(void) loginSucceed{
    NSString *loginFlagSTR = [Helper getValueByKey:ACQUIRER_LAUNCH_LOGIN_FLAG];
    //第一次启动应用后完成登录
    if (loginFlagSTR && [loginFlagSTR isEqualToString:NSSTRING_YES]) {
        self.window.rootViewController = transNavi;
        
        //show loading view
        [self.window bringSubviewToFront:[Acquirer sharedInstance].uiPromptHUD];
        
        cpTabBar = [[CPTabBar alloc] initWithFrame:CGRectMake(0, self.window.rootViewController.view.frame.size.height-DEFAULT_TAB_BAR_HEIGHT, self.window.frame.size.width, DEFAULT_TAB_BAR_HEIGHT)] ;
        cpTabBar.delegate = self;
        [cpTabBar setTabSelected:0];
        [self.window.rootViewController.view addSubview:cpTabBar];
        
        [Helper saveValue:NSSTRING_NO forKey:ACQUIRER_LAUNCH_LOGIN_FLAG];
        
        //做code.csv版本检查工作
        [[AcquirerService sharedInstance].codeCSVService requestForCodeCSVVersion];
        
    }else{
        [[Acquirer sharedInstance] hideUIPromptMessage:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGIN_SUCCEED object:nil];
    }
}

- (void)changeToIndex:(int)index
{
    static int curIndex = 0;
    
    CPNavigationController *cpNavi = [naviArray objectAtIndex:index];
    
    if (index != curIndex) {
        [cpTabBar removeFromSuperview];
        self.window.rootViewController = cpNavi;
        [self.window.rootViewController.view addSubview:cpTabBar];
        curIndex = index;
    }else{
        [cpNavi popToRootViewControllerAnimated:YES];
    }
}

- (void)performApplicationStartUpLogic{
    [self initializeUI];
    
    [Acquirer initializeAcquirer];

    [[AcquirerService sharedInstance].postbeService requestForUID];
    [[AcquirerService sharedInstance].postbeService requestForVersionCheck];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self performApplicationStartUpLogic];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
