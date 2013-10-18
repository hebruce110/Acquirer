//
//  TradeSettleQueryResViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-10-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleQueryResViewController.h"

@implementation TradeSettleQueryResViewController

@synthesize sqTableView;
@synthesize resendFlag;

-(void)dealloc{
    [sqTableView release];
    
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
        
        resendFlag = [DEFAULT_RESEND_FLAG copy];
        
        needRefreshTableView = YES;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"查询结果"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 10, self.contentView.bounds.size.width, 20);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [NSString stringWithFormat:@"%@ 至 %@", startDateSTR, endDateSTR];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    CGRect sqFrame = CGRectMake(0, 20, self.contentView.bounds.size.width,
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
    
    NSDateFormatter *formatterLocal = [[[NSDateFormatter alloc] init] autorelease];
    [formatterLocal setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginDate = [formatterLocal dateFromString:startDateSTR];
    NSDate *endDate = [formatterLocal dateFromString:endDateSTR];
    
    NSDateFormatter *formatterServer = [[[NSDateFormatter alloc] init] autorelease];
    [formatterServer setDateFormat:@"yyyyMMdd"];
    
    NSString *beginSTR = [formatterServer stringFromDate:beginDate];
    NSString *endSTR = [formatterServer stringFromDate:endDate];
    if (needRefreshTableView) {
        [[AcquirerService sharedInstance].settleService requestForSettleQuery:beginSTR
                                                                      endDate:endSTR
                                                                   resendFlag:resendFlag];
    }
}

-(void)processSettleQueryData:(NSDictionary *)body{
    
}

@end
