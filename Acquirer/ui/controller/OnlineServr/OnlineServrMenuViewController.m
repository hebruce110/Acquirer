//
//  OnlineServrMenuViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  在线服务主界面

#import "OnlineServrMenuViewController.h"
#import "ChatViewController.h"
#import "POSReportFormsViewController.h"
#import "ChinaPnrNotificationViewController.h"
#import "OnlineServrMenuCell.h"
#import "UIView+CustomBadge.h"
#import "MessageNumberData.h"

const NSString *badgeKey        = @"badgeKey";
const NSString *iconKey         = @"iconKey";
const NSString *titleKey        = @"titleKey";
const NSString *dateStringKey   = @"dateStringKey";
const NSString *classKey        = @"classKey";

@interface OnlineServrMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSArray *resArray;

@end

@implementation OnlineServrMenuViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
    
    self.tableView = nil;
    self.resArray = nil;
    
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
        self.isShowTabBar = YES;
        self.isShowRefreshBtn = NO;
        
        self.isNeedfresh = YES;
        _tableView = nil;
        _resArray = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"服务中心"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    [self.contentView addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needReloadTableDatas) name:DEF_MESSAGE_NUMBER_DID_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isNeedfresh) {
        self.isNeedfresh = NO;
        [self reloadTableDatas];
    }
}

- (void)needReloadTableDatas
{
    [self reloadTableDatas];
    self.isNeedRefresh = YES;
}

- (void)reloadTableDatas
{
    NSUInteger msgCount = [MessageNumberData messageCount];
    NSUInteger reportCount = [MessageNumberData reportCount];
    NSUInteger notifiCount = [MessageNumberData notificationCount];
    NSString *messageLastUpdateDateString = @"";
    NSString *reportLastUpdateDateString = @"";
    NSString *notificationLastUpdateDateString = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(msgCount > 0) {
        NSDate *onlineLastUpdateDate = [MessageNumberData messageLastUpdateDate];
        
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *cpComps = [calender components:unitFlags fromDate:onlineLastUpdateDate];
        NSDateComponents *todayComps = [calender components:unitFlags fromDate:[NSDate date]];
        [calender release];
        //当天
        if(cpComps.year == todayComps.year
           && cpComps.month == todayComps.month
           && cpComps.day == todayComps.day)
        {
            messageLastUpdateDateString = [NSString stringWithFormat:@"%0.2d:%0.2d", cpComps.hour, cpComps.minute];
        }
        else
        {
            messageLastUpdateDateString = [NSString stringWithFormat:@"%0.2d月%0.2d日", cpComps.month, cpComps.day];
        }
    }
    if(reportCount > 0) {
        NSDate *reportLastUpdateDate = [MessageNumberData reportLastUpdateDate];
        [formatter setDateFormat:@"MM月dd日"];
        reportLastUpdateDateString = [formatter stringFromDate:reportLastUpdateDate];
    }
    
    if(notifiCount > 0) {
        NSDate *notificationLastUpdateDate = [MessageNumberData notificationLastUpdateDate];
        [formatter setDateFormat:@"MM月dd日"];
        notificationLastUpdateDateString = [formatter stringFromDate:notificationLastUpdateDate];
    }
    
    [formatter release];
    self.resArray = @[@{badgeKey:@"0"/*客服聊天不计在内[NSString stringWithFormat:@"%u", msgCount]*/,
                        iconKey:@"icon_cus",
                        titleKey:@"在线客服",
                        dateStringKey:messageLastUpdateDateString,
                        classKey:ChatViewController.class
                        },
                      @{badgeKey:[NSString stringWithFormat:@"%u", reportCount],
                        iconKey:@"icon_report",
                        titleKey:@"POS增值报表",
                        dateStringKey:reportLastUpdateDateString,
                        classKey:POSReportFormsViewController.class
                        },
                      @{badgeKey:[NSString stringWithFormat:@"%u", notifiCount],
                        iconKey:@"icon_news",
                        titleKey:@"汇付公告",
                        dateStringKey:notificationLastUpdateDateString,
                        classKey:ChinaPnrNotificationViewController.class
                        }];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_resArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    OnlineServrMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[[OnlineServrMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSDictionary *dict = [_resArray objectAtIndex:indexPath.row];
    NSString *iconName = [dict objectForKey:iconKey];
    NSString *title = [dict objectForKey:titleKey];
    NSString *dateString = [dict objectForKey:dateStringKey];
    NSInteger badge = [[dict objectForKey:badgeKey] integerValue];
    
    cell.imageView.image = [UIImage imageNamed:iconName];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.dateLabel.text = dateString;
    cell.dateLabel.font = [UIFont systemFontOfSize:9];
    
    CGSize sz = [title sizeWithFont:cell.textLabel.font forWidth:320.0f lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat badgeX = 35.0f + sz.width + 5.0f;
    [cell.contentView setBadge:badge contentCenter:CGPointMake(badgeX + DEF_BADGE_HEIGHT / 2.0f, DEFAULT_ROW_HEIGHT / 2.0f)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

    NSArray *funcidArray = @[@"00000039",
                             @"00000040",
                             @"00000042"];
    NSString *postBeId = [funcidArray objectAtIndex:indexPath.row];
    [[AcquirerService sharedInstance].postbeService requestForPostbe:postBeId];
    
    NSDictionary *dict = [_resArray objectAtIndex:indexPath.row];
    Class jmpCls = [dict objectForKey:classKey];
    if(jmpCls && [jmpCls isSubclassOfClass:[UIViewController class]]) {
        UIViewController *jmpCtrl = [[jmpCls alloc] init];
        if([jmpCls isSubclassOfClass:[ChinaPnrNotificationViewController class]]) {
            ChinaPnrNotificationViewController *noticeViewCtrl = (ChinaPnrNotificationViewController *)jmpCtrl;
            noticeViewCtrl.msgFlag = messageNotice;
        }
        
        [self.navigationController pushViewController:jmpCtrl animated:YES];
        
        [jmpCtrl release];
    }
}

@end
