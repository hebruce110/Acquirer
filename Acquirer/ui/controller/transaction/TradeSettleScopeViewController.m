//
//  TradeSettleScopeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleScopeViewController.h"
#import "PlainCellContent.h"
#import "GeneralTableView.h"
#import "PlainTableCell.h"
#import "TradeSettleQueryResViewController.h"

@implementation TradeSettleScopeViewController

@synthesize dateScopeTV, sheetPicker, curIndexPath;

-(void)dealloc{
    [dateScopeTV release];
    [sheetPicker release];
    
    [curIndexPath release];
    
    [dsList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        dsList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpDateScopeList{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *secListOne = @[@"开始日期：", @"结束日期："];
    NSArray *templeList = @[secListOne];
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (NSString *title in secListOne) {
            PlainCellContent *pc = [[[PlainCellContent alloc] init] autorelease];
            pc.titleSTR = title;
            pc.textSTR = [formatter stringFromDate:[NSDate date]];
            [secList addObject:pc];
        }
        [dsList addObject:secList];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"结算查询"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(20, 10, 180, 20);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"请选择结算起止日期";
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    [self setUpDateScopeList];
    CGRect dsFrame = CGRectMake(0, 30, self.contentView.bounds.size.width, 105);
    self.dateScopeTV = [[[GeneralTableView alloc] initWithFrame:dsFrame style:UITableViewStyleGrouped] autorelease];
    [self.contentView addSubview:dateScopeTV];
    dateScopeTV.scrollEnabled = NO;
    
    [dateScopeTV setDelegateViewController:self];
    [dateScopeTV setGeneralTableDataSource:dsList];
    
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(dateScopeTV.frame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UIImage *offImg = [UIImage imageNamed:@"BUTT_whi_off.png"]; //[ resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)];
    UIImage *onImg = [UIImage imageNamed:@"BUTT_whi_on.png"]; //[ resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)];
    
    //140 * 40
    float btnWidth = 140;
    float btnHeigh = 40;
    
    UIButton *latestSevenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    latestSevenBtn.frame = CGRectMake(10, frameHeighOffset(dateScopeTV.frame)+VERTICAL_PADDING*2, btnWidth, btnHeigh);
    [latestSevenBtn setBackgroundImage:offImg forState:UIControlStateNormal];
    [latestSevenBtn setBackgroundImage:onImg forState:UIControlStateHighlighted];
    [latestSevenBtn setTitle:@"近七天内" forState:UIControlStateNormal];
    [latestSevenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    latestSevenBtn.layer.cornerRadius = 10.0;
    latestSevenBtn.clipsToBounds = YES;
    latestSevenBtn.tag = 1;
    [latestSevenBtn addTarget:self action:@selector(pressDateScopeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:latestSevenBtn];
    
    UIButton *latestMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    latestMonthBtn.frame = CGRectMake(self.contentView.bounds.size.width-10-btnWidth,
                                      frameHeighOffset(dateScopeTV.frame)+VERTICAL_PADDING*2, btnWidth, btnHeigh);
    [latestMonthBtn setBackgroundImage:offImg forState:UIControlStateNormal];
    [latestMonthBtn setBackgroundImage:onImg forState:UIControlStateHighlighted];
    [latestMonthBtn setTitle:@"上一个月" forState:UIControlStateNormal];
    [latestMonthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    latestMonthBtn.layer.cornerRadius = 10.0;
    latestMonthBtn.clipsToBounds = YES;
    latestMonthBtn.tag = 2;
    [latestMonthBtn addTarget:self action:@selector(pressDateScopeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:latestMonthBtn];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(latestMonthBtn.frame)+VERTICAL_PADDING*1.5, btnSelImg.size.width, btnSelImg.size.height);
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    queryBtn.frame = buttonFrame;
    queryBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), queryBtn.center.y);
    queryBtn.backgroundColor = [UIColor clearColor];
    [queryBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [queryBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    queryBtn.layer.cornerRadius = 10.0;
    queryBtn.clipsToBounds = YES;
    queryBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(pressQuery:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:queryBtn];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frameHeighOffset(buttonFrame)+VERTICAL_PADDING, 300, 20)];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    hintLabel.font = [UIFont systemFontOfSize:13];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    hintLabel.textColor = [UIColor redColor];
    hintLabel.text = @"提示：开始日期和结束日期跨度不能超过31天";
    [self.contentView addSubview:hintLabel];
    [hintLabel release];
}

-(void)setTableCellDate:(NSDate *)date anIndexPath:(NSIndexPath *)idp{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *plaincell = (PlainTableCell *)[dateScopeTV cellForRowAtIndexPath:idp];
    plaincell.textLabel.text = [formatter stringFromDate:date];
}

-(void)pressDateScopeBtn:(id)sender{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    UIButton *btn = (UIButton *)sender;
    //最近七天
    if (btn.tag == 1) {
        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
        [comps setDay:-7];
        NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        [self setTableCellDate:date anIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        //截止到昨天
        [comps setDay:-1];
        NSDate *yestoday = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        [self setTableCellDate:yestoday anIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    //上一个月
    else if (btn.tag == 2){
        NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
        [comps setMonth:-1];
        NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *comps2 = [calendar components:unitFlags fromDate:date];
        [comps2 setDay:1];
        NSDate *startDate = [calendar dateFromComponents:comps2];
        [self setTableCellDate:startDate anIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        [comps2 setDay:range.length];
        NSDate *endDate = [calendar dateFromComponents:comps2];
        [self setTableCellDate:endDate anIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
}

-(void)pressQuery:(id)sender{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *cellOne = (PlainTableCell *)[dateScopeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDate *startDate = [formatter dateFromString:cellOne.textLabel.text];
    
    PlainTableCell *cellTwo = (PlainTableCell *)[dateScopeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSDate *endDate = [formatter dateFromString:cellTwo.textLabel.text];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:endDate options:0];
    int length = comps.day;
    //开始日期和结束日期不能超过31天
    if (length >= 31) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"起始日期和结束日期跨度不能超过31天"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    //起始日期不能大于结束日期
    if ([startDate compare:endDate] == NSOrderedDescending) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"起始日期不能大于结束日期"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000006"];
    
    NSString *beginDateSTR = [formatter stringFromDate:startDate];
    NSString *endDateSTR = [formatter stringFromDate:endDate];
    TradeSettleQueryResViewController *tsrCTRL = [[TradeSettleQueryResViewController alloc] initWithStartDate:beginDateSTR endDate:endDateSTR];
    [self.navigationController pushViewController:tsrCTRL animated:YES];
    [tsrCTRL release];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.curIndexPath = indexPath;
    
    self.sheetPicker = [[[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.contentView] autorelease];
    [sheetPicker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
    [sheetPicker showActionSheetPicker];
    ((UIDatePicker *)sheetPicker.pickerView).maximumDate = [NSDate date];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *plaincell = (PlainTableCell *)[dateScopeTV cellForRowAtIndexPath:curIndexPath];
    plaincell.textLabel.text = [dateFormatter stringFromDate:selectedDate];
}

@end
