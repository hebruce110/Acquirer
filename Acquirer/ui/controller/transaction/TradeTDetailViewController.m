//
//  TradeTDetailViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTDetailViewController.h"
#import "TradeTDetailInfoViewController.h"
#import "DetailTableCell.h"
#import "DetailContent.h"

@implementation TradeTDetailViewController

@synthesize tradeType;
@synthesize beginDateSTR,endDateSTR;
@synthesize segControl, detailTableView, resendFlag;
@synthesize showMoreLabel, showMoreIndicator;

-(void)dealloc{
    [beginDateSTR release];
    [endDateSTR release];
    
    [segControl release];
    [detailTableView release];
    
    [tradeList release];
    [resendFlag release];
    
    [showMoreLabel release];
    [showMoreIndicator release];
    [super dealloc];
}

#define DEFAULT_RESEND_FLAG @"resendisnull"
-(id)init{
    self = [super init];
    if (self) {
        isShowRefreshBtn = NO;
        isShowMore = NO;
        tradeList = [[NSMutableArray alloc] init];
        resendFlag = [DEFAULT_RESEND_FLAG copy];
        self.isNeedRefresh = YES;
        
        //默认今日明细查询
        tradeType = TradeDetailToday;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (tradeType == TradeDetailToday) {
        [self setNavigationTitle:@"今日刷卡明细"];
    }else if(tradeType == TradeDetailHistory){
        [self setNavigationTitle:@"历史刷卡明细"];
    }
    else
    {
        [self setNavigationTitle:@"查询结果"];
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    CGRect dateFrame = CGRectMake(0, 10, 280, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), dateLabel.center.y);
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    if (tradeType == TradeDetailHistory){
        dateLabel.text = [NSString stringWithFormat:@"日期：%@ 至 %@", beginDateSTR, endDateSTR];
    }
    else {
        dateLabel.text = [NSString stringWithFormat:@"日期：%@", [dateFormatter stringFromDate:[NSDate date]]];
    }
    
    [self.contentView addSubview:dateLabel];
    [dateLabel release];
    
    reqFlagType = Req_Flag_All;
    self.segControl = [[[UISegmentedControl alloc] initWithItems:@[@"全部", @"成功", @"失败"]] autorelease];
    segControl.frame = CGRectMake(60, 40, 200, 30);
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segControl.tintColor = [UIColor darkGrayColor];
    segControl.multipleTouchEnabled = NO;
    [segControl setSelectedSegmentIndex:0];
    [self.contentView addSubview:segControl];
    [segControl addTarget:self action:@selector(segControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGRect detailFrame = CGRectMake(0, 80, self.contentView.bounds.size.width,
                                    self.contentView.bounds.size.height-segControl.frame.origin.y-segControl.frame.size.height-10);
    self.detailTableView = [[[UITableView alloc] initWithFrame:detailFrame style:UITableViewStyleGrouped] autorelease];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.backgroundView = nil;
    [contentView addSubview:detailTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.isNeedRefresh)
    {
        self.isNeedRefresh = NO;
        [self refreshTodayTradeDetail];
    }
}

-(void)refreshCurrentTableView{
    [tradeList removeAllObjects];
    self.resendFlag = DEFAULT_RESEND_FLAG;
    [self refreshTodayTradeDetail];
}

-(void)refreshTodayTradeDetail{
    NSDateFormatter *dsFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dsFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *sdFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [sdFormatter setDateFormat:@"yyyyMMdd"];
    
    if (tradeType == TradeDetailToday)
    {
        NSString *curDateSTR = [sdFormatter stringFromDate:[NSDate date]];
        [[AcquirerService sharedInstance].detailService onRespondTarget:self];
        [[AcquirerService sharedInstance].detailService requestForTradeDetail:Detail_Type_Today
                                                               withResendFlag:resendFlag
                                                                  withReqFlag:reqFlagType
                                                                   withCardNo:@""
                                                                      withAmt:@""
                                                                     fromDate:curDateSTR
                                                                       toDate:curDateSTR];
    }
    else
    if (tradeType == TradeDetailHistory || tradeType == TradeDetailTypeUnknow)
    {
        
        NSString *beginDateParamSTR = [sdFormatter stringFromDate:[dsFormatter dateFromString:beginDateSTR]];
        NSString *endDateParamSTR = [sdFormatter stringFromDate:[dsFormatter dateFromString:endDateSTR]];
        
        [[AcquirerService sharedInstance].detailService onRespondTarget:self];
        [[AcquirerService sharedInstance].detailService requestForTradeDetail:Detail_Type_History
                                                               withResendFlag:resendFlag
                                                                  withReqFlag:reqFlagType
                                                                   withCardNo:@""
                                                                      withAmt:@""
                                                                     fromDate:beginDateParamSTR
                                                                       toDate:endDateParamSTR];
    }
    
    
}

-(void)segControlChanged:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            reqFlagType = Req_Flag_All;
            break;
        case 1:
            reqFlagType = Req_Flag_Success;
            break;
        case 2:
            reqFlagType = Req_Flag_Failure;
            break;
        default:
            break;
    }
    
    self.resendFlag = DEFAULT_RESEND_FLAG;
    
    [tradeList removeAllObjects];
    [self refreshTodayTradeDetail];
}

-(void)processDetailData:(NSDictionary *)body
{
    if (NotNil(body, @"resend")) {
        self.resendFlag = [body objectForKey:@"resend"];
    }
    
    if (NotNilAndEqualsTo(body, @"endFlag", @"0")) {
        isShowMore = YES;
    }else if (NotNilAndEqualsTo(body, @"endFlag", @"1")){
        isShowMore = NO;
    }
    
    NSArray *ordList = [body objectForKey:@"ordList"];
    if (ordList==nil || ordList.count==0) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"没有数据" notifyType:NOTIFICATION_TYPE_WARNING];
    }
    

    NSDateFormatter *formatterString = [[[NSDateFormatter alloc] init] autorelease];
    [formatterString setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *formatterDate = [[[NSDateFormatter alloc] init] autorelease];
    [formatterDate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (NSDictionary *dict in ordList) {
        DetailContent *dc = [[[DetailContent alloc] init] autorelease];
        dc.orderIdSTR = [dict objectForKey:@"ordId"];
        dc.tradeAmtSTR = [dict objectForKey:@"amt"];
        dc.tradeTypeSTR = [dict objectForKey:@"transType"];
        dc.tradeStatSTR = [dict objectForKey:@"transStat"];
        dc.tradeTimeSTR = [formatterDate stringFromDate:[formatterString dateFromString:[dict objectForKey:@"transTime"]]];
        dc.bankCardSTR = [dict objectForKey:@"cardNo"];
        
        [tradeList addObject:dc];
    }
    
    [self.detailTableView reloadData];
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tradeList.count == 0) {
        return 1;
    }else{
        if (isShowMore) {
            return [tradeList count]+1;
        }
        return [tradeList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierDetail = @"Detail_Identifier";
    static NSString *identifierNoData = @"NoData_Identifier";
    static NSString *identifierShowMore = @"ShowMore_Identifier";
    
    if ([tradeList count] == 0) {
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
    
    if (isShowMore && indexPath.row==tradeList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierShowMore];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierShowMore] autorelease];
            self.showMoreLabel = [[[UILabel alloc] init] autorelease];
            showMoreLabel.frame = CGRectMake(0, 0, 200, cell.bounds.size.height);
            showMoreLabel.backgroundColor = [UIColor clearColor];
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
    
    DetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDetail];
    if (cell==nil) {
        cell = [[[DetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierDetail] autorelease];
    }
    
    DetailContent *dc = (DetailContent *)[tradeList objectAtIndex:indexPath.row];
    cell.bankCardLabel.text = dc.bankCardSTR;
    cell.tradeTimeLabel.text = dc.tradeTimeSTR;
    cell.tradeAmtLabel.text = [NSString stringWithFormat:@"%@元", dc.tradeAmtSTR];

    NSString *statStr = dc.tradeStatSTR;
    if(statStr && statStr.length > 0)
    {
        if([statStr isEqualToString:@"I"])      //初始
        {
            cell.tradeStatLabel.textColor = [UIColor grayColor];
        }
        else if([statStr isEqualToString:@"S"]) //成功
        {
            cell.tradeStatLabel.textColor = [UIColor greenColor];
        }
        else if([statStr isEqualToString:@"F"]) //失败
        {
            cell.tradeStatLabel.textColor = [UIColor redColor];
        }
        else if([statStr isEqualToString:@"C"]) //审核失败
        {
            cell.tradeStatLabel.textColor = [UIColor redColor];
        }
    }
    
    cell.tradeStatLabel.text = [[Acquirer sharedInstance] tradeStatDesc:dc.tradeStatSTR];
    cell.tradeTypeLabel.text = [[Acquirer sharedInstance] tradeTypeDesc:dc.tradeTypeSTR];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tradeList count] != 0) {
        //载入新的内容
        if (isShowMore && indexPath.row==tradeList.count) {
            showMoreLabel.text = @"载入中...";
            [showMoreIndicator startAnimating];
            
            [self refreshTodayTradeDetail];
            return;
        }
        
        if (tradeType == TradeDetailToday) {
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000004"];
        }else if (tradeType == TradeDetailHistory || tradeType == TradeDetailTypeUnknow){
            [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000016"];
        }
        
        //跳转操作
        TradeTDetailInfoViewController *ttdi = [[[TradeTDetailInfoViewController alloc] init] autorelease];
        ttdi.orderIdSTR = ((DetailContent *)[tradeList objectAtIndex:indexPath.row]).orderIdSTR;
        [self.navigationController pushViewController:ttdi animated:YES];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
}

@end
