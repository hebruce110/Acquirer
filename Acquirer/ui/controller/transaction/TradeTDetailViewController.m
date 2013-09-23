//
//  TradeTDetailViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-23.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeTDetailViewController.h"
#import "DetailTableCell.h"

@implementation TradeTDetailViewController

@synthesize segControl, detailTableView;

-(void)dealloc{
    [segControl release];
    [detailTableView release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        isShowRefreshBtn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"今日刷卡明细"];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    CGRect dateFrame = CGRectMake(0, 10, 160, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), dateLabel.center.y);
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.text = [NSString stringWithFormat:@"日期：%@", [dateFormatter stringFromDate:[NSDate date]]];
    [self.contentView addSubview:dateLabel];
    [dateLabel release];
    
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
    self.detailTableView = [[UITableView alloc] initWithFrame:detailFrame style:UITableViewStyleGrouped];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [contentView addSubview:detailTableView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)segControlChanged:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

#pragma mark UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [[plainList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Plain_Identifier";
    
    DetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[DetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
    PlainContent *content = [[plainList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.titleLabel.text = content.titleSTR;
    cell.textLabel.text = content.textSTR;
    */
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
}

@end
