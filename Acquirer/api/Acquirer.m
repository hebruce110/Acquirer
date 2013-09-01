//
//  Acquirer.m
//  Acquirer
//
//  Created by chinapnr on 13-8-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "Acquirer.h"
#import "AcquirerCPRequest.h"
#import "DeviceIntrospection.h"
#import "Settings.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Helper.h"

static Acquirer *sInstance = nil;

@implementation Acquirer

@synthesize uiPromptHUD, sysPromptHUD;

-(void)dealloc{
    [uiPromptHUD release];
    [sysPromptHUD release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        uiPromptHUD = nil;
        sysPromptHUD = nil;
    }
    return self;
}

+(Acquirer *)sharedInstance{
    if (sInstance == nil) {
        sInstance = [[Acquirer alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

//initialize global settings
+(void)initializeAcquirer{
    
    Acquirer *instance = [Acquirer sharedInstance];
    
    [Settings sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(requireUserLogin:)
                                                 name:NOTIFICATION_REQUIRE_USER_LOGIN
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]	addObserver:instance
											 selector:@selector(applicationWillTerminate)
												 name:UIApplicationWillTerminateNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(displayUIPromptAutomatically:)
                                                 name:NOTIFICATION_UI_AUTO_PROMPT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(displaySysPromptAutomatically:)
                                                 name:NOTIFICATION_SYS_AUTO_PROMPT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(displayTitaniumProtoPromptAutomatically:)
                                                 name:NOTIFICATION_TITANIUM_PROMPT
                                               object:nil];
}

+(void)shutdown{
    Acquirer *instance = [Acquirer sharedInstance];
    if (instance == nil) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:instance];
    
    [Acquirer destroySharedInstance];
}

+(NSString *)bundleVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

//Set global PosMini request
-(void)performRequest:(ASIHTTPRequest *)req
{
    //set CHINAPNR json post
    if (req && [req.requestMethod isEqualToString:@"POST"]) {
        if ([req respondsToSelector:@selector(setPostBodyFormat:)]) {
            [(ASIFormDataRequest *)req setPostBodyFormat:ASIURLEncodedPostJSONFormat];
        }
    }
    
    //construct seession cookie
    //NSHTTPCookiePath and NSHTTPCookieDomain is required, or NSHTTPCookie will return nil
    NSString *sessionStr = [Helper getValueByKey:POSMINI_LOCAL_SESSION];
    if (sessionStr!=nil && ![sessionStr isEqualToString:@"#"])
    {
        NSMutableDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
        [properties setValue:POSMINI_MTP_SESSION forKey:NSHTTPCookieName];
        [properties setValue:sessionStr forKey:NSHTTPCookieValue];
        [properties setValue:@"\\" forKey:NSHTTPCookiePath];
        [properties setValue:req.url.host forKey:NSHTTPCookieDomain];
        
        NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
        
        [req setUseCookiePersistence:NO];
        [req setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    }
}

//用户重新登录
-(void)requireUserLogin:(NSNotification *)notify{
    /*
    if ([[Helper getValueByKey:POSMINI_SHOW_USER_LOGIN] isEqualToString:NSSTRING_NO]) {
        RequireLoginViewController *rl = [[RequireLoginViewController alloc] init];
        rl.isShowNaviBar = NO;
        rl.isShowTabBar = NO;
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentModalViewController:rl animated:YES];
        [rl release];
    }
    */
}

#pragma mark -
#pragma mark UIPromptMessage methods
/*
 *　显示UI loading消息
 */
-(void) showUIPromptMessage:(NSString *)message animated:(BOOL)animated
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (uiPromptHUD == nil)
    {
        self.uiPromptHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [window bringSubviewToFront:sysPromptHUD];
        uiPromptHUD.tag = MBPHUD_UI_PROMPT_TAG;
        uiPromptHUD.delegate = self;
        uiPromptHUD.mode = MBProgressHUDModeIndeterminate;
        uiPromptHUD.removeFromSuperViewOnHide = NO;
        [uiPromptHUD show:animated];
    }
    uiPromptHUD.labelText = message;
}

//隐藏loading消息
-(void) hideUIPromptMessage:(BOOL)animated
{
    if (uiPromptHUD)
    {
        [uiPromptHUD hide:animated];
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

//clean up HUD object
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	// Remove HUD from screen when the HUD was hidded
    switch (hud.tag) {
        case MBPHUD_UI_PROMPT_TAG:
            [uiPromptHUD removeFromSuperview];
            self.uiPromptHUD = nil;
            break;
            
        case MBPHUD_SYS_PROMPT_TAG:
            [sysPromptHUD removeFromSuperview];
            self.sysPromptHUD = nil;
            break;
    }
}

-(void) displayUIPromptAutomatically:(NSNotification *)notification
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
	
	hud.mode = MBProgressHUDModeIndeterminate;
	hud.labelText = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5];
}

-(void) displaySysPromptAutomatically:(NSNotification *)notification
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5];
}

#define PROMPT_IMAGEVIEW_TAG 20
#define PROMPT_LABEL_TEXT_WIDTH 130

-(void) displayTitaniumProtoPromptAutomatically:(NSNotification *)notification
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    //add transparent bg
    UIView *promptBgView = [[[UIView alloc] initWithFrame:window.bounds] autorelease];
    promptBgView.backgroundColor = [UIColor clearColor];
    promptBgView.userInteractionEnabled = YES;
    [window addSubview:promptBgView];
    
    CGFloat offset = 0.0f;
    UIImage *promptImg = nil;
    
    NSString *promptType = [notification.userInfo objectForKey:NOTIFICATION_TYPE];
    if (promptType && [promptType isEqualToString:NOTIFICATION_TYPE_ERROR]) {
        offset = 50.0f;
        promptImg = [UIImage imageNamed:@"info_error.png"];
    }
    else if (promptType && [promptType isEqualToString:NOTIFICATION_TYPE_WARNING]){
        promptImg = [UIImage imageNamed:@"info_warning.png"];
    }
    else if (promptType && [promptType isEqualToString:NOTIFICATION_TYPE_SUCCESS]){
        promptImg = [UIImage imageNamed:@"info_success.png"];
    }
    else{
        promptImg = [UIImage imageNamed:@"info_warning.png"];
    }
    
    
    UIImageView *promptImgView = [[[UIImageView alloc] initWithImage:promptImg] autorelease];
    promptImgView.tag = PROMPT_IMAGEVIEW_TAG;
    promptImgView.frame = CGRectMake(promptBgView.bounds.size.width, 0, promptImg.size.width, promptImg.size.height);
    promptImgView.center = CGPointMake(promptImgView.center.x, window.center.y+offset);
    [promptBgView addSubview:promptImgView];
    
    NSString *msgString = [notification.userInfo objectForKey:NOTIFICATION_MESSAGE];

    CGFloat msgLabelHeight = [Helper getLabelHeight:msgString setfont:[UIFont boldSystemFontOfSize:15] setwidth:PROMPT_LABEL_TEXT_WIDTH];
    
    UILabel *msgLabel = [[[UILabel alloc] init] autorelease];
    msgLabel.text = msgString;
    msgLabel.frame = CGRectMake(55, 0, PROMPT_LABEL_TEXT_WIDTH, msgLabelHeight);
    msgLabel.center = CGPointMake(msgLabel.center.x, CGRectGetMidY(promptImgView.bounds)-2);
    msgLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [promptImgView addSubview:msgLabel];
    
    //do animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        promptImgView.frame = CGRectMake(promptBgView.bounds.size.width-promptImg.size.width, promptImgView.frame.origin.y,
                                         promptImg.size.width, promptImg.size.height);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionCurveEaseInOut animations:^{
            promptImgView.frame = CGRectMake(promptImgView.frame.origin.x + promptImgView.bounds.size.width,
                                             promptImgView.frame.origin.y,
                                             promptImgView.bounds.size.width, promptImgView.bounds.size.height);
        }completion:^(BOOL finished){
            [promptBgView removeFromSuperview];
        }];
    }];
}

-(void)applicationWillTerminate{
	[Acquirer shutdown];
}


@end






































