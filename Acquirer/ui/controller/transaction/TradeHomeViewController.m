//
//  TransHomeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeHomeViewController.h"
#import "TradeTSummaryViewController.h"
#import "TradeTDetailViewController.h"
#import "TradeSettleMgtViewController.h"
#import "TradeHScopeViewController.h"

@interface TradeHomeViewController ()

@end

@implementation TradeHomeViewController

@synthesize tradeTableView;

-(void)dealloc{
    [tradeTableView release];
    
    [imageList release];
    [titleList release];
    
    [classList release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        imageList = [[NSArray arrayWithObjects:@"tradetodaygather.png",
                                                @"tradetodaylist.png",
                                                @"tradesettle.png",
                                                @"tradehistorylist.png", nil] retain];
        
        titleList = [[NSArray arrayWithObjects:@"今日刷卡汇总",
                                                @"今日刷卡明细",
                                                @"结算管理",
                                                @"历史刷卡汇总", nil] retain];
        
        classList = [[NSArray arrayWithObjects: TradeTSummaryViewController.class,
                                                TradeTDetailViewController.class,
                                                TradeSettleMgtViewController.class,
                                                TradeHScopeViewController.class, nil] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"刷卡交易"];
	
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGRect tradeFrame = CGRectMake(0, 20, contentWidth, contentHeight-20);
    self.tradeTableView = [[[UITableView alloc] initWithFrame:tradeFrame style:UITableViewStyleGrouped] autorelease];
    tradeTableView.delegate = self;
    tradeTableView.dataSource = self;
    tradeTableView.backgroundColor = [UIColor clearColor];
    tradeTableView.backgroundView = nil;
    
    [self.contentView addSubview:tradeTableView];
}


#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Trade_Main_Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [titleList objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[imageList objectAtIndex:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class ViewController = [classList objectAtIndex:indexPath.row];
    BaseViewController *CTRL = [[[ViewController alloc] init] autorelease];
    [self.navigationController pushViewController:CTRL animated:YES];
    
    if ([CTRL isKindOfClass:TradeTSummaryViewController.class]) {
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000010"];
    }else if ([CTRL isKindOfClass:TradeTDetailViewController.class]){
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000011"];
    }else if ([CTRL isKindOfClass:TradeSettleMgtViewController.class]){
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000012"];
    }
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
}

@end
