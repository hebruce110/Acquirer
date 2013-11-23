//
//  SLBDetailListViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBDetailListViewController.h"
#import "SLBDetailListCell.h"
#import "SLBService.h"
#import "SLBHelper.h"
#import "SafeObject.h"

//detail list row高
#define DEFAULT_SLB_DETAIL_ROW_HEIGHT   64.0

@interface SLBDetailListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UILabel *showMoreLabel;
@property (retain, nonatomic) UIActivityIndicatorView *showMoreIndicator;

@property (retain, nonatomic) UITableView *listTableView;

@property (retain, nonatomic) NSMutableArray *detailList;

@property (copy, nonatomic) NSString *resend;
@property (assign, nonatomic) BOOL isShowMore;

@end

@implementation SLBDetailListViewController

- (void)dealloc
{
    [_showMoreLabel release];
    _showMoreLabel = nil;
    
    [_showMoreIndicator release];
    _showMoreIndicator = nil;
    
    [_listTableView release];
    _listTableView = nil;
    
    [_detailList release];
    _detailList = nil;
    
    [_resend release];
    _resend = nil;
    
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
        _isNeedfresh = YES;
        _isShowMore = NO;
        
        _showMoreLabel = nil;
        _showMoreIndicator = nil;
        _resend = nil;
        _detailList = nil;
        _listTableView = nil;
    }
    return self;
}

#define DEFAULT_RESEND_FLAG @"resendisnull"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"生利宝明细"];
    
    _showMoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _showMoreLabel.tag = 100;
    _showMoreLabel.textAlignment = NSTextAlignmentCenter;
    _showMoreLabel.backgroundColor = [UIColor clearColor];
    _showMoreLabel.font = [UIFont systemFontOfSize:16];
    
    _showMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _showMoreIndicator.center = CGPointMake(100, 22);
    
    _resend = [DEFAULT_RESEND_FLAG copy];
    _detailList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _listTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _listTableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    _listTableView.backgroundView = nil;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    [self.contentView addSubview:_listTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_isNeedfresh)
    {
        _isNeedfresh = NO;
        
        [self reloadData];
    }
}

- (void)reloadData
{
    [self slbQueryDetail];
}

- (void)slbQueryDetail
{
    [[SLBService sharedService].detailListSer requestForResend:_resend taget:self action:@selector(slbQueryDetailDidFinished:)];
}

- (void)slbQueryDetailDidFinished:(AcquirerCPRequest *)request
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
    
    NSArray *ordList = [body safeJsonObjForKey:@"infoList"];
    if (ordList==nil || ordList.count==0) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"没有数据" notifyType:NOTIFICATION_TYPE_WARNING];
    }
    
    if(!_detailList)
    {
        _detailList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_detailList addObjectsFromArray:ordList];
    
    [_listTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detailList.count == 0) {
        return 1;
    }else{
        if (_isShowMore) {
            return [_detailList count]+1;
        }
        return [_detailList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *slbDetailCellNoDataIdentifier = @"slbDetailCellNoDataIdentifier";
    static NSString *slbDetailCellShowMoreIdentifier = @"slbDetailCellShowMoreIdentifier";
    static NSString *slbDetailCellIdentifier = @"slbDetailCellIdentifier";
    if ([_detailList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:slbDetailCellNoDataIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slbDetailCellNoDataIdentifier] autorelease];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = @"没有记录";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    if (_isShowMore && indexPath.row == _detailList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:slbDetailCellShowMoreIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slbDetailCellShowMoreIdentifier] autorelease];
            _showMoreLabel.frame = CGRectMake(0, 0, 200, cell.bounds.size.height);
            _showMoreLabel.center = CGPointMake(CGRectGetMidX(cell.bounds), _showMoreLabel.center.y);
            [cell addSubview:_showMoreLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
            [cell addSubview:_showMoreIndicator];
            [_showMoreIndicator stopAnimating];
        }
        ((UILabel *)[cell viewWithTag:100]).text = @"更多";
        return cell;
    }
    
    
    SLBDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:slbDetailCellIdentifier];
    if(!cell)
    {
        cell = [[[SLBDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:slbDetailCellIdentifier] autorelease];
    }
    
    NSDictionary *dict = [_detailList safeObjectAtIndex:indexPath.row];
    
    NSString *tranTimeString = [dict safeJsonObjForKey:@"tranTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [formatter dateFromString:tranTimeString];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *tranTime = [formatter stringFromDate:date];
    [formatter release];
    
    CGFloat tranAmt = [[dict safeJsonObjForKey:@"tranAmt"] floatValue];
    NSString *tranType = [dict safeJsonObjForKey:@"tranType"];
    
    
    BOOL inOut = NO;
    if(tranType && [tranType isEqualToString:@"I"])
    {
        inOut = YES;
    }
    UIImage *img = inOut ? [UIImage imageNamed:@"SLB_icon_in"] : [UIImage imageNamed:@"SLB_icon_out"];
    cell.icImageView.image = img;
    
    if(inOut)
    {
        cell.typeLabel.text = @"存入";
        cell.typeLabel.textAlignment = NSTextAlignmentCenter;
        cell.typeLabel.textColor = [UIColor slbGreenColor];
    }
    else
    {
        cell.typeLabel.text = @"转出";
        cell.typeLabel.textAlignment = NSTextAlignmentCenter;
        cell.typeLabel.textColor = [UIColor slbRedColor];
    }
    
    NSString *amountStr = [NSString stringWithFormat:@"%@元", [NSString micrometerSymbolAmount:tranAmt]];
    NSMutableAttributedString *amountAttributedStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    CTFontRef amountCTFont18 = [UIFont systemFontOfSize:18].ctFont;
    CTFontRef amountCTFont12 = [UIFont systemFontOfSize:10].ctFont;
    [amountAttributedStr beginEditing];
    [amountAttributedStr addAttribute:(id)kCTFontAttributeName value:(id)amountCTFont18 range:NSMakeRange(0, amountAttributedStr.length)];
    [amountAttributedStr addAttribute:(id)kCTFontAttributeName value:(id)amountCTFont12 range:NSMakeRange(MAX(0, amountAttributedStr.length - 1), 1)];
    [amountAttributedStr endEditing];
    
    CFRelease(amountCTFont18);
    CFRelease(amountCTFont12);
    
    [cell.amountView setAttributeString:amountAttributedStr];
    [amountAttributedStr release];
    
    cell.dateLabel.font = [UIFont systemFontOfSize:11];
    cell.dateLabel.textColor = [UIColor grayColor];
    cell.dateLabel.text = tranTime;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return (cell);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_detailList && (_detailList.count > 0) && (indexPath.row != _detailList.count))
    {
        return (DEFAULT_SLB_DETAIL_ROW_HEIGHT);
    }
    return (DEFAULT_ROW_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_detailList count] != 0) {
        //载入新的内容
        if (_isShowMore && indexPath.row == _detailList.count) {
            _showMoreLabel.text = @"载入中...";
            [_showMoreIndicator startAnimating];
            
            [self reloadData];
            return;
        }
    }
}

@end
