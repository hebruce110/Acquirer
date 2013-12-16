//
//  TradeHDetailViewController.m
//  Acquirer
//
//  Created by soal on 13-11-21.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeHDetailViewController.h"
#import "TradeTDetailViewController.h"
#import "ActionSheetDatePicker.h"
#import "PlainTableCell.h"

@interface TradeHDetailViewController ()

@property (retain, nonatomic) ActionSheetDatePicker *datePicker;
@property (retain, nonatomic) PlainTableCell *dateCell;

@end

@implementation TradeHDetailViewController

- (void)dealloc
{
    self.dateCell = nil;
    self.datePicker = nil;
    
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
        _dateCell = nil;
        _datePicker = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"历史刷卡明细"];
    
    CGSize ctSize = self.contentView.bounds.size;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0, ctSize.width - 40.0f, DEFAULT_ROW_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"请选择查询历史刷卡明细的日期";
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _dateCell = [[PlainTableCell alloc] init];
    _dateCell.frame = CGRectMake(_dateCell.indentationWidth, CGRectGetMaxY(titleLabel.frame), ctSize.width - _dateCell.indentationWidth * 2.0f, CGRectGetHeight(titleLabel.frame));
    _dateCell.titleLabel.text = @"日期:";
    _dateCell.textLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    _dateCell.backgroundColor = [UIColor whiteColor];
    _dateCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _dateCell.layer.borderWidth = 1.0f;
    _dateCell.layer.cornerRadius = 6.0f;
    _dateCell.clipsToBounds = YES;
    
    CGRect tlFm = _dateCell.titleLabel.frame;
    tlFm.origin.x = _dateCell.indentationWidth;
    _dateCell.titleLabel.frame = tlFm;
    
    CGRect txFm = _dateCell.textLabel.frame;
    txFm.origin.x -= 30.0f;
    _dateCell.textLabel.frame = txFm;
    [self.contentView addSubview:_dateCell];
    
    UITapGestureRecognizer *cellTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTaped:)];
    [_dateCell addGestureRecognizer:cellTapGesture];
    [cellTapGesture release];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(10.0f, 300.0f, 300.0f, 57.0f);
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
}

- (void)cellTaped:(UITapGestureRecognizer *)gesture
{
    if([gesture.view isEqual:_dateCell])
    {
        _dateCell.backgroundColor = [UIColor lightGrayColor];
        [UIView animateWithDuration:0.2f animations:^(void){
            _dateCell.backgroundColor = [UIColor whiteColor];
        }];
        
        _datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:self.contentView];
        [_datePicker addCustomButtonWithTitle:@"今天" value:[NSDate date]];
        [_datePicker showActionSheetPicker];
        ((UIDatePicker *)_datePicker.pickerView).maximumDate = [NSDate date];
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    _dateCell.textLabel.text = [dateFormatter stringFromDate:selectedDate];
}

- (void)pressQuery:(id)sender
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000015"];
    
    TradeTDetailViewController *tradeDetailCTRL = [[[TradeTDetailViewController alloc] init] autorelease];
    tradeDetailCTRL.tradeType = TradeDetailHistory;
    tradeDetailCTRL.beginDateSTR = _dateCell.textLabel.text;
    tradeDetailCTRL.endDateSTR = _dateCell.textLabel.text;
    tradeDetailCTRL.tradeType = TradeDetailTypeUnknow;
    [self.navigationController pushViewController:tradeDetailCTRL animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = [touch view];
    if([touchView isKindOfClass:[UIControl class]])
    {
        return (NO);
    }
    return (YES);
}

@end
