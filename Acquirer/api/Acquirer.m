//
//  Acquirer.m
//  Acquirer
//
//  Created by chinapnr on 13-8-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "Acquirer.h"
#import "CPRequest.h"
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
@synthesize codeCSVVersion;
@synthesize uidSTR;
@synthesize logReason;

-(void)dealloc{
    [codeList release];
    
    [uiPromptHUD release];
    [sysPromptHUD release];
    
    [codedescMap release];
    [currentUser release];
    
    [uidSTR release];
    
    [tradeTypeDict release];
    [tradeStatDict release];
    [settleStatDict release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        uiPromptHUD = nil;
        sysPromptHUD = nil;
        currentUser = nil;
        
        codeList = [[NSMutableArray alloc] init];
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
    
    [instance initTradeTypeAndStatCode];
    
    //初始化code.csv版本
    [instance initCodeCSVVersion];
    //拷贝code.csv文件到Documents目录
    [instance copyConfigFileToDocuments];
    
    //解析MTP服务端返回码对应的描述文字
    [instance parseReturnCodeDescFile];
    
    //initialize app startup nsuserdefault settings
    [Helper saveValue:ACQUIRER_DEFAULT_VALUE forKey:ACQUIRER_LOCAL_SESSION_KEY];
    //设置登录原因为每次应用启动
    instance.logReason = LoginAppLunchEachTime;
    
    
    
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

//初始化code.csv版本
-(void)initCodeCSVVersion{
    NSString *codeCSVSTR = [Helper getValueByKey:CODE_CSV_VERSION];
    if ([Helper stringNullOrEmpty:codeCSVSTR]) {
        codeCSVVersion = -1;
    }else{
        codeCSVVersion = [codeCSVSTR intValue];
    }
}

//初始化交易类型和交易状态
-(void)initTradeTypeAndStatCode{
    tradeTypeDict = [@{@"P":@"消费",
                     @"Y":@"预授权",
                     @"W":@"预授权完成",
                     @"Q":@"消费撤销",
                     @"C":@"预授权撤销",
                     @"D":@"预授权完成撤销",
                     @"R":@"退货"} copy];
    tradeStatDict = [@{@"I":@"初始",
                     @"S":@"成功",
                     @"F":@"失败",
                     @"C":@"审核失败"} copy];
    
    settleStatDict = [@{@"I":@"处理中",
                       @"D":@"处理中",
                       @"P":@"汇付已汇出",
                       @"F":@"失败",
                       @"S":@"成功"} copy];
}

//交易类型
-(NSString *)tradeTypeDesc:(NSString *)tradeTypeCode{
    if (NotNil(tradeTypeDict, tradeTypeCode)) {
        return [tradeTypeDict objectForKey:tradeTypeCode];
    }
    return @"";
}

//交易状态
-(NSString *)tradeStatDesc:(NSString *)tradeStatCode{
    if (NotNil(tradeStatDict, tradeStatCode)) {
        return [tradeStatDict objectForKey:tradeStatCode];
    }
    return @"";
}

//结算状态
-(NSString *)settleStatDesc:(NSString *)settleStatCode{
    if (NotNil(settleStatDict, settleStatCode)) {
        return [settleStatDict objectForKey:settleStatCode];
    }
    return @"";
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
    
    //set CHINAPNR json get
    if (req && [req.requestMethod isEqualToString:@"GET"]) {
        NSString *path = [NSString stringWithFormat:@"%@://%@%@", req.url.scheme, req.url.host, req.url.path];

        NSMutableString *querySTR = [NSMutableString stringWithString:@""];
        
        NSArray *paramList = [req.url.query componentsSeparatedByString:@"&"];
        NSUInteger i = 0;
        NSUInteger count = [paramList count]-1;
        [querySTR appendString:@"jsonStr={"];
        for (NSString *param in paramList)
        {
            NSArray *kv = [param componentsSeparatedByString:@"="];
            NSString *paramSTR = [NSString stringWithFormat:@"\"%@\":\"%@\"%@",
                                  [kv objectAtIndex:0], [kv objectAtIndex:1],(i<count ?  @"," : @"")];
            [querySTR appendString:paramSTR];
            i++;
        }
        [querySTR appendString:@"}"];
        
        /*
         NSURL expects URLString to contain any necessary percent escape codes, which are ‘:’, ‘/’, ‘%’, ‘#’, ‘;’, and ‘@’.
         The characters escaped are all characters that are not legal URL characters(based on RFC 3986),
         plus any characters in legalURLCharactersToBeEscaped, less any characters in charactersToLeaveUnescaped.
         */
        NSString *encodedQuerySTR = [(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)querySTR,
                                                                                        NULL, NULL, kCFStringEncodingUTF8) autorelease];
        NSString *urlSTR = [NSString stringWithFormat:@"%@?%@", path, encodedQuerySTR];
        NSURL *newUrl = [NSURL URLWithString:urlSTR];
        [req setURL:newUrl];
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
    self.logReason = LoginSessionTimeOut;
    LoginViewController *loginCTRL = [[[LoginViewController alloc] init] autorelease];
    CPNavigationController *loginNavi = [[[CPNavigationController alloc] initWithRootViewController:loginCTRL] autorelease];
    loginNavi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:loginNavi animated:YES completion:NULL];
}

//拷贝文件到documents目录下
//srcPath:工程路径 destPath:目标路径
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

//解析服务端下载的code.csv文件
-(void)parseCodeCSVFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *destPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"code.csv"];
    
    NSError *error = nil;
    NSString *codeCSVSTR = [NSString stringWithContentsOfFile:destPath encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@", codeCSVSTR);
    
    if (error) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:[error description] notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if (![Helper stringNullOrEmpty:codeCSVSTR]) {
        //清空所有code对应信息
        [codeList removeAllObjects];
        
        //按每行处理
        NSArray *lines = [codeCSVSTR componentsSeparatedByString:@"\n"];
        for (NSString *line in lines) {
            //空白行不做处理
            if ([Helper stringNullOrEmpty:line]) {
                continue;
            }
            
            CodeInfo *codeInfo = [[[CodeInfo alloc] init] autorelease];
            
            //解析状态码类型　刷卡返回码｜刷卡详情失败原因｜结算失败原因
            NSCharacterSet *splitCharSet = [NSCharacterSet characterSetWithCharactersInString:@",，"];
            
            NSRange typeRange = [line rangeOfCharacterFromSet:splitCharSet];
            NSString *typeSTR = [line substringWithRange:NSMakeRange(0, typeRange.location)];
            codeInfo.codeTypeSTR = typeSTR;
            
            //对应状态码
            line = [line substringFromIndex:typeRange.location+1];
            NSRange codeRange = [line rangeOfCharacterFromSet:splitCharSet];
            NSString *codeSTR = [line substringWithRange:NSMakeRange(0, codeRange.location)];
            codeInfo.codeNumSTR = codeSTR;
            
            //描述文字
            NSString *descSTR = [line substringFromIndex:codeRange.location+1];
            codeInfo.codeDesc = descSTR;
        
            [codeList addObject:codeInfo];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"code.csv文件解析错误，请联系客服"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
    }
    
}

//code.csv状态码描述
//状态失败的状态码对应的原因
-(NSString *)codeCSVDesc:(NSString *)codeSTR{
    for (CodeInfo *info in codeList) {
        if ([info.codeNumSTR isEqualToString:codeSTR]) {
            return info.codeDesc;
        }
    }
    return @"";
}

//解析MTP服务端返回码对应的描述文字
-(void)parseReturnCodeDescFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RespCodeDesc" ofType:@"geojson"];
    NSError *err = NULL;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&err];
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
        [window bringSubviewToFront:uiPromptHUD];
        uiPromptHUD.mode = MBProgressHUDModeIndeterminate;
    }
    
    [uiPromptHUD show:animated];
    uiPromptHUD.labelText = message;
}

//隐藏loading消息
-(void) hideUIPromptMessage:(BOOL)animated
{
    [uiPromptHUD hide:animated];
    self.uiPromptHUD = nil;
}

-(void)applicationWillTerminate:(NSNotification *)notification{
	[Acquirer shutdown];
}


@end

@implementation CodeInfo

@synthesize codeTypeSTR, codeNumSTR, codeDesc;

-(void)dealloc{
    [codeTypeSTR release];
    [codeNumSTR release];
    [codeDesc release];
    
    [super dealloc];
}

@end
