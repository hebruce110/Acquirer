//
//  TradeSettleScopeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeSettleScopeViewController.h"
#import "PlainContent.h"
#import "PlainTableView.h"

@implementation TradeSettleScopeViewController

@synthesize dateScopeTV;

-(void)dealloc{
    [dateScopeTV release];
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
            PlainContent *pc = [[[PlainContent alloc] init] autorelease];
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
    
    [self setUpDateScopeList];
    CGRect dsFrame = CGRectMake(0, 30, self.contentView.bounds.size.width, 105);
    self.dateScopeTV = [[PlainTableView alloc] initWithFrame:dsFrame style:UITableViewStyleGrouped];
    dateScopeTV.backgroundColor = [UIColor clearColor];
    dateScopeTV.backgroundView = nil;
    [self.contentView addSubview:dateScopeTV];
    dateScopeTV.scrollEnabled = NO;
    
    [dateScopeTV setDelegateViewController:self];
    [dateScopeTV setPlainTableDataSource:dsList];
    
    
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
    latestSevenBtn.tag = 2;
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
}

-(void)pressDateScopeBtn:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    //最近七天
    if (btn.tag == 1) {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
    }else if (btn.tag == 2){
        
    }
}

-(void)pressQuery:(id)sender{
    
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
