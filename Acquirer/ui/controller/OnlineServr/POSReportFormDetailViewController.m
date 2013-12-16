//
//  POSReportFormDetailViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  增值报表详情

#import "POSReportFormDetailViewController.h"

@interface POSReportFormDetailViewController () <UIScrollViewDelegate, UIWebViewDelegate>

@property (retain, nonatomic) UIWebView *webView;

@property (retain, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation POSReportFormDetailViewController

- (void)dealloc
{
    [_webView stopLoading];
    self.webView = nil;
    self.indicatorView = nil;
    self.rptMsg = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
        self.isNeedRefresh = YES;
        
        _webView = nil;
        _indicatorView = nil;
        _rptMsg = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"增值报表"];
    
    _webView = [[UIWebView alloc] initWithFrame:self.contentView.bounds];
    _webView.delegate = self;
    [self.contentView addSubview:_webView];
    
    [self addRightItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isNeedRefresh) {
        self.isNeedRefresh = NO;
        
        NSURL *url = [MessageNumberData reportDetailUrlByDateString:_rptMsg.dateString act:_rptMsg.typeString];
        [_webView stopLoading];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)addRightItem
{
    UIImage *rightItemImg = [[UIImage imageNamed:@"nav-btn.png"] stretchableImageWithLeftCapWidth:30.0f topCapHeight:15.0f];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[rightItemImg resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 6.0f, 10.0f, 6.0f)] forState:UIControlStateNormal];
    rightItemButton.frame = CGRectMake(self.naviBgView.bounds.size.width - 80.0f, 0, 70.0f, 29.0f);
    rightItemButton.center = CGPointMake(rightItemButton.center.x, CGRectGetMidY(naviBgView.bounds));
    [rightItemButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightItemButton addTarget:self action:@selector(rightItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBgView addSubview:rightItemButton];
}

- (void)rightItemButtonTouched:(id)sender
{
    //取消订阅(分刷卡交易数据和交易收入数据，不针对具体一个月的报表)
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"取消订阅后无法接收新的报表服务，是否取消订阅？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

//显示加载提示
- (void)showIndiCator
{
    if(!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(self.contentView.bounds.size.width / 2.0f, self.contentView.bounds.size.height / 2.0f);
    }
    [self.contentView addSubview:_indicatorView];
    [_indicatorView startAnimating];
}

//隐藏加载提示
- (void)hideIndicator
{
    if(_indicatorView) {
        [_indicatorView stopAnimating];
        [_indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return (YES);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showIndiCator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicator];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击取消订阅弹出框的"确定"
    if(buttonIndex == 1) {
        [self cancelReportFormService];
    }
}

#pragma mark - network
//取消订阅
- (void)cancelReportFormService
{
    [[AcquirerService sharedInstance].onlineService requestUpdateReportInfoByFlag:@"2" reportType:_rptMsg.typeString isSubscribe:@"N" target:self action:@selector(cancelReportFormServiceDidFinished:)];
}

//取消订阅回调
- (void)cancelReportFormServiceDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    if(NotNilAndEqualsTo(body, @"isSucc", @"1")) {
        [MessageNumberData setReportType:_rptMsg.typeString isSubScribed:NO];
        
        [self backToPreviousView:nil];
    }
}

@end
