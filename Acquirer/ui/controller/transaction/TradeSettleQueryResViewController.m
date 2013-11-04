//
//  TradeSettleQueryResViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleQueryResViewController.h"
#import "SettleQueryContent.h"
#import "SettleQueryTableCell.h"
#import "TradeSettleQueryInfoViewController.h"

@implementation TradeSettleQueryResViewController

@synthesize sqTableView;
@synthesize resendFlag;
@synthesize showMoreLabel;
@synthesize showMoreIndicator;

-(void)dealloc{
    [sqTableView release];
    
    [sqList release];
    
    [startDateSTR release];
    [endDateSTR release];
    
    [resendFlag release];
    [super dealloc];
}

#define DEFAULT_RESEND_FLAG @"resendisnull"
-(id)initWithStartDate:(NSString *)startSTR endDate:(NSString *)endSTR{
    self = [super init];
    if (self) {
        startDateSTR = [startSTR copy];
        endDateSTR = [endSTR copy];
        
        sqList = [[NSMutableArray alloc] init];
        
        resendFlag = [DEFAULT_RESEND_FLAG copy];
        
        needRefreshTableView = YES;
        isShowMore = NO;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"查询结果"];
    
    [sqList removeAllObjects];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 10, self.contentView.bounds.size.width, 20);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startDateSTR, endDateSTR];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    CGRect sqFrame = CGRectMake(0, 30, self.contentView.bounds.size.width,
                                    self.contentView.bounds.size.height-10);
    self.sqTableView = [[[UITableView alloc] initWithFrame:sqFrame style:UITableViewStyleGrouped] autorelease];
    sqTableView.delegate = self;
    sqTableView.dataSource = self;
    sqTableView.backgroundColor = [UIColor clearColor];
    sqTableView.backgroundView = nil;
    [contentView addSubview:sqTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (needRefreshTableView) {
        [self requestForSettleQuery];
    }
}

//请求结算查询
-(void)requestForSettleQuery{
    NSDateFormatter *formatterLocal = [[[NSDateFormatter alloc] init] autorelease];
    [formatterLocal setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [formatterLocal dateFromString:startDateSTR];
    NSDate *endDate = [formatterLocal dateFromString:endDateSTR];
    
    NSDateFormatter *formatterServer = [[[NSDateFormatter alloc] init] autorelease];
    [formatterServer setDateFormat:@"yyyyMMdd"];
    
    NSString *beginSTR = [formatterServer stringFromDate:beginDate];
    NSString *endSTR = [formatterServer stringFromDate:endDate];
    
    [[AcquirerService sharedInstance].settleService onRespondTarget:self];
    [[AcquirerService sharedInstance].settleService requestForSettleQuery:beginSTR
                                                                  endDate:endSTR
                                                               resendFlag:resendFlag];
}

-(void)processSettleQueryData:(NSDictionary *)body{
    if (NotNil(body, @"resend")) {
        self.resendFlag = [body objectForKey:@"resend"];
    }
    
    if (NotNilAndEqualsTo(body, @"endFlag", @"0")) {
        isShowMore = YES;
    }else{
        isShowMore = NO;
    }
    
    NSArray *queryList = [body objectForKey:@"balInfoList"];
    if (queryList==nil || queryList.count==0) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"没有数据"
                                                                     notifyType:NOTIFICATION_TYPE_WARNING];
    }
    
    for (NSDictionary *dict in queryList) {
        SettleQueryContent *sqModel = [[[SettleQueryContent alloc] init] autorelease];
        sqModel.accountIdSTR = [dict objectForKey:@"acctId"];
        sqModel.balAmtSTR = [dict objectForKey:@"balAmt"];
        
        sqModel.balDateSTR = [dict objectForKey:@"balDate"];
        
        sqModel.balSeqIdSTR = [dict objectForKey:@"balSeqId"];
        sqModel.balStatSTR = [dict objectForKey:@"balStat"];
        sqModel.cashChannelSTR = [dict objectForKey:@"cashChannel"];
        
        [sqList addObject:sqModel];
    }
    [self.sqTableView reloadData];
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (sqList.count == 0) {
        return 1;
    }else{
        if (isShowMore) {
            return [sqList count]+1;
        }
        return [sqList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierDetail = @"Detail_Identifier";
    static NSString *identifierNoData = @"NoData_Identifier";
    static NSString *identifierShowMore = @"ShowMore_Identifier";
    
    if ([sqList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNoData];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierNoData] autorelease];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = @"没有记录";
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    if (isShowMore && indexPath.row==sqList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShowMore];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierShowMore] autorelease];
            self.showMoreLabel = [[[UILabel alloc] init] autorelease];
            showMoreLabel.frame = CGRectMake(0, 0, 200, cell.bounds.size.height);
            showMoreLabel.center = CGPointMake(CGRectGetMidX(cell.bounds), showMoreLabel.center.y);
            showMoreLabel.textAlignment = NSTextAlignmentCenter;
            showMoreLabel.font = [UIFont systemFontOfSize:16];
            showMoreLabel.tag = 1;
            [cell addSubview:showMoreLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            self.showMoreIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            showMoreIndicator.center = CGPointMake(100, 22);
            [cell addSubview:showMoreIndicator];
            [showMoreIndicator stopAnimating];
        }
        ((UILabel *)[cell viewWithTag:1]).text = @"更多";
        return cell;
    }
    
    SettleQueryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDetail];
    if (cell==nil) {
        cell = [[[SettleQueryTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierDetail] autorelease];
    }
    
    SettleQueryContent *dc = (SettleQueryContent *)[sqList objectAtIndex:indexPath.row];
    cell.bankCardLabel.text = dc.accountIdSTR;
    
    NSDateFormatter *formatterString = [[[NSDateFormatter alloc] init] autorelease];
    [formatterString setDateFormat:@"yyyyMMdd"];
    NSDateFormatter *formatterDate = [[[NSDateFormatter alloc] init] autorelease];
    [formatterDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *balDate = [formatterString dateFromString:dc.balDateSTR];
    NSString *balDateSTR = [formatterDate stringFromDate:balDate];
    cell.tradeTimeLabel.text = balDateSTR;
    
    cell.balanceAmtLabel.text = [NSString stringWithFormat:@"%@元", dc.balAmtSTR];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"sqList count:%d", sqList.count);
    
    if ([sqList count] != 0) {
        //载入新的内容
        if (isShowMore && indexPath.row==sqList.count) {
            showMoreLabel.text = @"载入中...";
            [showMoreIndicator startAnimating];
            
            [self requestForSettleQuery];
            return;
        }
        
        //跳转操作
        needRefreshTableView = NO;
        
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000007"];
        
        SettleQueryContent *sqContent = [sqList objectAtIndex:indexPath.row];
        TradeSettleQueryInfoViewController *tsqiCTRL = [[[TradeSettleQueryInfoViewController alloc] init] autorelease];
        tsqiCTRL.sqContent = sqContent;
        [self.navigationController pushViewController:tsqiCTRL animated:YES];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
}

@end















