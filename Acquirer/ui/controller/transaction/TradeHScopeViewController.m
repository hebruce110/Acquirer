//
//  TradeHScopeViewController.m
//  Acquirer
//
//  Created by peer on 10/29/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeHScopeViewController.h"
#import "PlainCellContent.h"
#import "GeneralTableView.h"
#import "PlainTableCell.h"
#import "TradeHSummaryViewController.h"

@implementation TradeHScopeViewController

@synthesize historyScopeTV, curIndexPath, stringPicker, datePicker;
@synthesize devIdSTR;


-(void)dealloc{
    [hsList release];
    [historyScopeTV release];
    [stringPicker release];
    [datePicker release];
    
    [devList release];
    [devIdSTR release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        hsList = [[NSMutableArray alloc] init];
        devList = [[NSMutableArray arrayWithArray:[Acquirer sharedInstance].currentUser.devList] retain];
        [devList insertObject:@"全部" atIndex:0];
        
        devIdSTR = [[NSString stringWithFormat:@"全部"] retain];
    }
    return self;
}

-(void)setUpHistoryScopeList{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    
    PlainCellContent *terminalSNContent = [[[PlainCellContent alloc] init] autorelease];
    terminalSNContent.titleSTR = @"终端号";
    terminalSNContent.textSTR = @"全部";
    terminalSNContent.cellStyle = Cell_Style_Plain;
    [secOne addObject:terminalSNContent];
    
    PlainCellContent *startDateContent = [[[PlainCellContent alloc] init] autorelease];
    startDateContent.titleSTR = @"开始日期";
    startDateContent.textSTR = [dateFormatter stringFromDate:[NSDate date]];
    startDateContent.cellStyle = Cell_Style_Plain;
    [secOne addObject:startDateContent];
    
    PlainCellContent *endDateContent = [[[PlainCellContent alloc] init] autorelease];
    endDateContent.titleSTR = @"结束日期";
    endDateContent.textSTR = [dateFormatter stringFromDate:[NSDate date]];
    endDateContent.cellStyle = Cell_Style_Plain;
    [secOne addObject:endDateContent];
    
    [hsList addObject:secOne];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat contentWidth = self.contentView.bounds.size.width;
    
    [self setNavigationTitle:@"历史刷卡汇总"];
    
    [self setUpHistoryScopeList];
    CGRect scopeFrame = CGRectMake(0, 10, contentWidth, 145);
    self.historyScopeTV = [[GeneralTableView alloc] initWithFrame:scopeFrame style:UITableViewStyleGrouped];
    [historyScopeTV setDelegateViewController:self];
    [historyScopeTV setGeneralTableDataSource:hsList];
    historyScopeTV.scrollEnabled = NO;
    [self.contentView addSubview:historyScopeTV];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(scopeFrame)+VERTICAL_PADDING*2, dashImg.size.width, dashImg.size.height);
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
    latestSevenBtn.frame = CGRectMake(10, frameHeighOffset(dashFrame)+VERTICAL_PADDING*2, btnWidth, btnHeigh);
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
                                      frameHeighOffset(dashFrame)+VERTICAL_PADDING*2, btnWidth, btnHeigh);
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
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(latestMonthBtn.frame)+VERTICAL_PADDING*2, btnSelImg.size.width, btnSelImg.size.height);
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
}

-(void)pressQuery:(id)sender{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *cellOne = (PlainTableCell *)[historyScopeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSDate *startDate = [formatter dateFromString:cellOne.textLabel.text];
    
    PlainTableCell *cellTwo = (PlainTableCell *)[historyScopeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
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
    
    NSString *beginDateSTR = [formatter stringFromDate:startDate];
    NSString *endDateSTR = [formatter stringFromDate:endDate];
    
    TradeHSummaryViewController *thsCTRL = [[[TradeHSummaryViewController alloc] init] autorelease];
    thsCTRL.beginDateSTR = beginDateSTR;
    thsCTRL.endDateSTR = endDateSTR;
    thsCTRL.devIdSTR = devIdSTR;
    [self.navigationController pushViewController:thsCTRL animated:YES];
}

-(void)setTableCellDate:(NSDate *)date anIndexPath:(NSIndexPath *)idp{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *plaincell = (PlainTableCell *)[historyScopeTV cellForRowAtIndexPath:idp];
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
        [self setTableCellDate:date anIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        //截止到昨天
        [comps setDay:-1];
        NSDate *yestoday = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        [self setTableCellDate:yestoday anIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
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
        [self setTableCellDate:startDate anIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        [comps2 setDay:range.length];
        NSDate *endDate = [calendar dateFromComponents:comps2];
        [self setTableCellDate:endDate anIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    }
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.curIndexPath = indexPath;
    if (indexPath.row == 0) {
        self.stringPicker = [[[ActionSheetStringPicker alloc] initWithTitle:@"" rows:devList initialSelection:0 target:self successAction:@selector(devWasSelected:element:) cancelAction:nil origin:self.contentView] autorelease];
        [stringPicker showActionSheetPicker];
        
    }else{
        self.datePicker = [[[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.contentView] autorelease];
        [datePicker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
        [datePicker showActionSheetPicker];
        ((UIDatePicker *)datePicker.pickerView).maximumDate = [NSDate date];
    }
}


- (void)devWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.devIdSTR = [devList objectAtIndex:[selectedIndex intValue]];
    
    PlainTableCell *cell = (PlainTableCell *) [historyScopeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text = devIdSTR;
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    PlainTableCell *plaincell = (PlainTableCell *)[historyScopeTV cellForRowAtIndexPath:curIndexPath];
    plaincell.textLabel.text = [dateFormatter stringFromDate:selectedDate];
}

@end
