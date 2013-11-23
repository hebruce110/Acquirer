//
//  NoticeViewController.m
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeDetailViewController.h"
#import "NoticeAddViewController.h"
#import "SafeObject.h"
#import "AppDelegate.h"

@interface NoticeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;

@property (retain, nonatomic) UILabel *showMoreLabel;
@property (retain, nonatomic) UIActivityIndicatorView *showMoreIndicator;

@property (assign, nonatomic) BOOL isShowMore;
@property (copy, nonatomic) NSString *resend;
@property (retain, nonatomic) NSMutableArray *msgList;

@property (retain, nonatomic) NSString *listKey;
@property (retain, nonatomic) NSString *textKey;
@property (retain, nonatomic) NSString *dateKey;

@end

@implementation NoticeViewController

- (void)dealloc
{
    [_showMoreLabel release];
    _showMoreLabel = nil;
    
    [_showMoreIndicator release];
    _showMoreIndicator = nil;
    
    [_tableView release];
    _tableView = nil;
    
    [_msgList release];
    _msgList = nil;
    
    [_resend release];
    _resend = nil;
    
    [_listKey release];
    _listKey = nil;
    
    [_textKey release];
    _textKey = nil;
    
    [_dateKey release];
    _dateKey = nil;
    
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
        _msgFlag = messageUnknow;
        _isNeedRefresh = YES;
        _isShowMore = YES;
        _msgList = nil;
        _tableView = nil;
        _resend = nil;
        
        _showMoreLabel = nil;
        _showMoreIndicator = nil;
        
        self.listKey = @"infoList";
        self.textKey = @"title";
        self.dateKey = @"releaseDate";
    }
    return self;
}

#define DEFAULT_RESEND_FLAG @"resendisnull"
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _msgList = [[NSMutableArray alloc] initWithCapacity:0];
    _resend = [DEFAULT_RESEND_FLAG copy];
    
    _showMoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _showMoreLabel.tag = 100;
    _showMoreLabel.textAlignment = NSTextAlignmentCenter;
    _showMoreLabel.backgroundColor = [UIColor clearColor];
    _showMoreLabel.font = [UIFont systemFontOfSize:16];
    
    _showMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _showMoreIndicator.center = CGPointMake(100, 22);
    
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.contentView addSubview:_tableView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    switch(_msgFlag)
    {
        case messageNotice:
        {
            [self setNavigationTitle:@"公告"];
            self.listKey = @"infoList";
            self.textKey = @"title";
            self.dateKey = @"releaseDate";
        }break;
            
        case messageNotificatin:
        {
            [self setNavigationTitle:@"通知"];
            self.listKey = @"infoList";
            self.textKey = @"title";
            self.dateKey = @"releaseDate";
        }break;
            
        case messageLeaveMsg:
        {
            [self setNavigationTitle:@"留言"];
            self.listKey = @"msgList";
            self.textKey = @"title";
            self.dateKey = @"date";
            [self addRightItem];
        }break;
            
        case messageUnknow:
            default:
            break;
    }
    
    if(_isNeedRefresh)
    {
        _isNeedRefresh = NO;
        [self reFreshMessage];
    }
}

- (void)addRightItem
{
    UIImage *rightItemImg = [UIImage imageNamed:@"nav-btn.png"];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[rightItemImg resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 6.0f, 10.0f, 6.0f)]
                               forState:UIControlStateNormal];
    rightItemButton.frame = CGRectMake(self.naviBgView.bounds.size.width - 70.0f, 0, 60.0f, 29.0f);
    rightItemButton.center = CGPointMake(rightItemButton.center.x, CGRectGetMidY(naviBgView.bounds));
    [rightItemButton setTitle:@"新留言" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightItemButton addTarget:self action:@selector(rightItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBgView addSubview:rightItemButton];
}

- (void)rightItemButtonTouched:(id)sender
{
    NoticeAddViewController *noticeAddViewCtrl = [[NoticeAddViewController alloc] init];
    [self.navigationController pushViewController:noticeAddViewCtrl animated:YES];
    [noticeAddViewCtrl release];
}

#pragma mark - network

- (void)reFreshMessage
{
    [_msgList removeAllObjects];
    self.resend = DEFAULT_RESEND_FLAG;
    [self freshMessage];
}

- (void)freshMessage
{
    NoticeService *noticeService = [AcquirerService sharedInstance].noticeService;
    switch(_msgFlag)
    {
        case messageNotice:
        {
            [noticeService requestNoticeListByResend:_resend flag:_msgFlag reportFlag:messageReportNotice Taget:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageNotificatin:
        {
            [noticeService requestNoticeListByResend:_resend flag:_msgFlag reportFlag:messageReportNotification Taget:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageLeaveMsg:
        {
            [noticeService requestLeaveMessageByResend:_resend Taget:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageUnknow:
        default:
            break;
    }
}

- (void)requestDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    
    if (NotNil(body, @"resend")) {
        self.resend = [body safeJsonObjForKey:@"resend"];
    }
    
    if (NotNilAndEqualsTo(body, @"endFlag", @"0")) {
        _isShowMore = YES;
    }else if (NotNilAndEqualsTo(body, @"endFlag", @"1")){
        _isShowMore = NO;
    }
    
    NSArray *ordList = [body safeJsonObjForKey:self.listKey];
    if (ordList == nil || ordList.count == 0) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"没有数据" notifyType:NOTIFICATION_TYPE_WARNING];
    }
    
    if(!_msgList)
    {
        _msgList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_msgList addObjectsFromArray:ordList];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_msgList.count == 0) {
        return 1;
    }else{
        if (_isShowMore) {
            return [_msgList count] + 1;
        }
        return [_msgList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *noIdentifier = @"noIdentifier";
    static NSString *cellIdentifier = @"noticeCellIdentifier";
    static NSString *moreIdentifier = @"moreIdentifier";
    
    if ([_msgList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noIdentifier] autorelease];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = @"没有记录";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    if (_isShowMore && indexPath.row == _msgList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreIdentifier] autorelease];
            _showMoreLabel.frame = CGRectMake(0, 0, 200, cell.bounds.size.height);
            _showMoreLabel.center = CGPointMake(CGRectGetMidX(cell.bounds), _showMoreLabel.center.y);
            [cell.contentView addSubview:_showMoreLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            [cell.contentView addSubview:_showMoreIndicator];
            [_showMoreIndicator stopAnimating];
        }
        ((UILabel *)[cell viewWithTag:100]).text = @"更多";
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSDictionary *dict = [_msgList safeObjectAtIndex:indexPath.row];
    
    NSString *tranTimeString = [dict safeJsonObjForKey:self.dateKey];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:tranTimeString];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *tranTime = [formatter stringFromDate:date];
    [formatter release];
    
    NSString *title = [dict safeJsonObjForKey:self.textKey];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = tranTime;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return (cell);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_msgList.count == 0 || _msgList.count == indexPath.row)
    {
        return (DEFAULT_ROW_HEIGHT);
    }
    return (64.0f);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_msgList count] != 0) {
        //载入新的内容
        if (_isShowMore && indexPath.row == _msgList.count) {
            [_showMoreIndicator startAnimating];
            [self freshMessage];
        }
        else
        {
            NSDictionary *dict = [_msgList safeObjectAtIndex:indexPath.row];
            NSString *idCountStr = [dict safeJsonObjForKey:@"id"];
            NoticeDetailViewController *detailViewCtrl = [[NoticeDetailViewController alloc] init];
            detailViewCtrl.msgFlag = _msgFlag;
            detailViewCtrl.idCountStr = idCountStr;
            [self.navigationController pushViewController:detailViewCtrl animated:YES];
            [detailViewCtrl release];
        }
    }
}

@end
