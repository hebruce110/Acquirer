//
//  ChatTimeLabelCell.m
//  Acquirer
//
//  Created by peer on 11/21/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatTimeLabelCell.h"
#import "Helper.h"

@implementation ChatTimeLabelCell

-(void)dealloc{
    [timeLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        timeLabel = [[UILabel alloc] init];
        timeLabel.bounds = CGRectMake(0, 0, 180, CHAT_TIME_LABEL_HEIGHT);
        timeLabel.font = [UIFont boldSystemFontOfSize:14];
        timeLabel.textColor = [Helper hexStringToColor:@"#FFFFFF"];
        timeLabel.backgroundColor = [[Helper hexStringToColor:@"#000000"] colorWithAlphaComponent:0.1f];
        timeLabel.layer.cornerRadius = 10;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeLabel];
    }
    return self;
}

-(void)layoutSubviews{
    timeLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

-(void)formatDateTime:(NSDate *)date{
    NSArray *weekDayList = @[@"", @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
    NSCalendar *calender = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps = [calender components:unitFlags fromDate:date];
    
    int year =  [comps year];
    int month = [comps month];
    int day = [comps day];
    int week = [comps weekday];
    
    int hour = [comps hour];
    int min = [comps minute];
    
    NSString *minSTR = min<10 ? [NSString stringWithFormat:@"0%d", min]:[NSString stringWithFormat:@"%d", min];
    
    NSString *dateSTR = [NSString stringWithFormat:@"%d.%d.%d %@ %d:%@", year, month, day, [weekDayList objectAtIndex:week], hour, minSTR];
    timeLabel.text = dateSTR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
