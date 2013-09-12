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
#import "LoginViewController.h"
#import "CPNavigationController.h"
#import "AcquirerService.h"
#import "JSON.h"

static Acquirer *sInstance = nil;

@implementation Acquirer

@synthesize uiPromptHUD, sysPromptHUD;
@synthesize codedescMap, currentUser;
@synthesize configVersion;
@synthesize uidSTR;

-(void)dealloc{
    [uiPromptHUD release];
    [sysPromptHUD release];
    
    [codedescMap release];
    [currentUser release];
    
    [configVersion release];
    
    [uidSTR release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        uiPromptHUD = nil;
        sysPromptHUD = nil;
        currentUser = nil;
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

+(void)shutdown{
    Acquirer *instance = [Acquirer sharedInstance];
    if (instance == nil) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:instance];
    
    [Settings destroySharedInstance];
    [AcquirerService destroySharedInstance];
    
    [Acquirer destroySharedInstance];
}

//initialize global settings
+(void)initializeAcquirer{
    
    Acquirer *instance = [Acquirer sharedInstance];
    
    [Settings sharedInstance];
    [AcquirerService sharedInstance];
    
    [instance copyConfigFileToDocuments];
    [instance parseCodeDescFile];
    
    //initialize app startup nsuserdefault settings
    [Helper saveValue:ACQUIRER_DEFAULT_VALUE forKey:ACQUIRER_LOCAL_SESSION_KEY];
    [Helper saveValue:NSSTRING_YES forKey:ACQUIRER_LAUNCH_LOGIN_FLAG];
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(presentLoginViewController:)
                                                 name:NOTIFICATION_REQUIRE_USER_LOGIN
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]	addObserver:instance
											 selector:@selector(applicationWillTerminate:)
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

+(NSString *)bundleVersion{
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"v%@", versionNumber];
}

+(NSString *)UID{
    NSString *uid = [Helper getValueByKey:POSTBE_UID];
    if ([Helper stringNullOrEmpty:uid] || [uid isEqualToString:ACQUIRER_DEFAULT_VALUE]) {
        [[AcquirerService sharedInstance].postbeService requestForUID];
        return @"";
    }
    return uid;
}

//check is production environment
+(BOOL)isProductionEnvironment{
    if ([HOST_URL rangeOfString:@"test"].location==NSNotFound) {
        return YES;
    }
    return NO;
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
    NSString *sessionStr = [Helper getValueByKey:ACQUIRER_LOCAL_SESSION_KEY];
    if (sessionStr!=nil && ![sessionStr isEqualToString:ACQUIRER_DEFAULT_VALUE])
    {
        NSMutableDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
        [properties setValue:ACQUIRER_MTP_SESSION_KEY forKey:NSHTTPCookieName];
        [properties setValue:sessionStr forKey:NSHTTPCookieValue];
        [properties setValue:@"\\" forKey:NSHTTPCookiePath];
        [properties setValue:req.url.host forKey:NSHTTPCookieDomain];
        
        NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
        
        [req setUseCookiePersistence:NO];
        [req setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    }
}

//用户重新登录
- (void)presentLoginViewController:(NSNotification *)notification{
    LoginViewController *loginCTRL = [[[LoginViewController alloc] init] autorelease];
    CPNavigationController *loginNavi = [[[CPNavigationController alloc] initWithRootViewController:loginCTRL] autorelease];
    loginNavi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:loginNavi animated:YES completion:NULL];
}

-(void)copyConfigFileToDocuments{

    NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"csv"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] >= 1)
    {
        NSString *destPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"code.csv"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *err = nil;
        if (![fm fileExistsAtPath:destPath]) {
            if (![fm copyItemAtPath:srcPath toPath:destPath error:&err]) {
                NSLog(@"code.csv :%@", [err localizedDescription]);
            }
        }
    }
}

-(void)parseCodeDescFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RespCodeDesc" ofType:@"geojson"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    codedescMap = [[content JSONValue] retain];    
}

-(NSString *)respDesc:(NSString *)codeSTR{
    if (NotNil(self.codedescMap, codeSTR)) {
        return [self.codedescMap objectForKey:codeSTR];
    }
    return [NSString stringWithFormat:@"服务器错误,　请稍后再试"];
}

#pragma mark -
#pragma mark UIPromptMessage methods

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
    
    CGFloat msgLabelHeight = [Helper getLabelHeight:msgString setfont:[UIFont systemFontOfSize:14.0] setwidth:PROMPT_LABEL_TEXT_WIDTH];
    
    UILabel *msgLabel = [[[UILabel alloc] init] autorelease];
    msgLabel.text = msgString;
    msgLabel.lineBreakMode = UILineBreakModeWordWrap;
    msgLabel.numberOfLines = 0;
    msgLabel.frame = CGRectMake(55, 0, PROMPT_LABEL_TEXT_WIDTH, msgLabelHeight);
    msgLabel.center = CGPointMake(msgLabel.center.x, CGRectGetMidY(promptImgView.bounds));
    msgLabel.font = [UIFont systemFontOfSize:14.0];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.textColor = [UIColor blackColor];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    [promptImgView addSubview:msgLabel];
    
    //do animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        promptImgView.frame = CGRectMake(promptBgView.bounds.size.width-promptImg.size.width, promptImgView.frame.origin.y,
                                         promptImg.size.width, promptImg.size.height);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.3 delay:1.8 options:UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionCurveEaseInOut animations:^{
            promptImgView.frame = CGRectMake(promptImgView.frame.origin.x + promptImgView.bounds.size.width,
                                             promptImgView.frame.origin.y,
                                             promptImgView.bounds.size.width, promptImgView.bounds.size.height);
        }completion:^(BOOL finished){
            [promptBgView removeFromSuperview];
        }];
    }];
}

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



-(void)applicationWillTerminate:(NSNotification *)notification{
	[Acquirer shutdown];
}


@end






































