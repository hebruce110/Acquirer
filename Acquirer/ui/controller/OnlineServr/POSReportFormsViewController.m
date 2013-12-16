//
//  POSReportFormsViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  增值报表

#import "POSReportFormsViewController.h"
#import "POSReportFormDetailViewController.h"
#import "POSReportFormCell.h"
#import "MessageNumberData.h"

@interface POSReportFormsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (retain, nonatomic) NSArray *reportArray;

@end

@implementation POSReportFormsViewController

- (void)dealloc
{
    self.tableView = nil;
    self.reportArray = nil;
    
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
        
        self.isNeedfresh = YES;
        _selectedIndex = 0;
        _tableView = nil;
        _reportArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"增值报表"];
    
    _reportArray = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    [self.contentView addSubview:_tableView];
    
    [MessageNumberData sharedData];
    [MessageNumberData setReportCount:0 report:([MessageNumberData reportCount] > 0)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isNeedfresh) {
        self.isNeedfresh = NO;
        
        self.reportArray = [[MessageNumberData sharedData] updateReportUnreadIdList:nil];
        
        [_tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_reportArray && _reportArray.count > 0)
    {
        return (_reportArray.count);
    }
    return (1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!(_reportArray && _reportArray.count > 0))
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = @"暂无数据";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    static NSString *cellIdentifier = @"cellIdentifier";
    POSReportFormCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[[POSReportFormCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.dateLabel.textColor = [UIColor grayColor];
    cell.imgView.hidden = YES;
    
    NSString *rtString = [_reportArray objectAtIndex:indexPath.row];
    ReportMessage *msg = [MessageNumberData reportByReportString:rtString];
    
    NSString *title = [NSString stringWithFormat:@"%@-%@", msg.month, msg.title];
    cell.textLabel.text = title;
    cell.dateLabel.text = msg.year;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return (cell);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (DEFAULT_ROW_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_reportArray && _reportArray.count > 0)
    {
        _selectedIndex = indexPath.row;
        
        NSString *rtString = [_reportArray objectAtIndex:indexPath.row];
        ReportMessage *msg = [MessageNumberData reportByReportString:rtString];
        
        //统计
        if(msg.typeString && [msg.typeString isEqualToString:@"0106"]) {
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000044"];
        }
        else if(msg.typeString && [msg.typeString isEqualToString:@"0107"]) {
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000043"];
        }
        
        BOOL isSubscribe = [MessageNumberData isSubScribedByReportType:msg.typeString];
        //BOOL isPay = [MessageNumberData isNeedPayByReportType:msg.typeString];
        
        //点击后请求数据，看是否已订阅，若没有订阅，则弹出提示框(是否订阅:确定、取消)
        if(isSubscribe) {
            [self jumpToDetailIndex:indexPath.row];
        } else {
            NSDictionary *info = [MessageNumberData reportInfoByReportType:msg.typeString];
            //订阅
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[info objectForKey:@"remark"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击alertView的"确定"
    if(buttonIndex == 1) {
        [self SubscriptionService];
    }
}

#pragma mark - network
//订阅
- (void)SubscriptionService
{
    NSString *rtString = [_reportArray objectAtIndex:_selectedIndex];
    ReportMessage *msg = [MessageNumberData reportByReportString:rtString];
    [[AcquirerService sharedInstance].onlineService requestUpdateReportInfoByFlag:@"2" reportType:msg.typeString isSubscribe:@"Y" target:self action:@selector(SubscriptionServiceDidFinished:)];
}

- (void)SubscriptionServiceDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    if(NotNilAndEqualsTo(body, @"isSucc", @"1")) {
        NSString *rtString = [_reportArray objectAtIndex:_selectedIndex];
        ReportMessage *msg = [MessageNumberData reportByReportString:rtString];
        [MessageNumberData setReportType:msg.typeString isSubScribed:YES];
        [self jumpToDetailIndex:_selectedIndex];
    }
}

#pragma mark -
//跳转到报表详情页
- (void)jumpToDetailIndex:(NSInteger)index
{
    NSString *rtString = [_reportArray objectAtIndex:_selectedIndex];
    ReportMessage *msg = [MessageNumberData reportByReportString:rtString];
    
    POSReportFormDetailViewController *detailPosCtrl = [[POSReportFormDetailViewController alloc] init];
    detailPosCtrl.rptMsg = msg;
    [self.navigationController pushViewController:detailPosCtrl animated:YES];
    [detailPosCtrl release];
}
@end
