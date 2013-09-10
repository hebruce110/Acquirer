//
//  ValiIdentityViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ValiIdentityViewController.h"
#import "FormCellPattern.h"

@interface ValiIdentityViewController ()

@end

@implementation ValiIdentityViewController

@synthesize posOrderTableView;

-(void)dealloc{
    [posOrderTableView release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        isShowNaviBar = YES;
        isShowTabBar = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"身份验证"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    
    FormCellPattern *pattern = [[[FormCellPattern alloc] init] autorelease];
    pattern.titleSTR = @"订单号前8位：";
    pattern.placeHolderSTR = @"POS小票订单号前8位";
    
    NSMutableArray *patternList = [[[NSMutableArray alloc] init] autorelease];
    [patternList addObject:pattern];
    
    CGRect tableFrame = CGRectMake(0, 90, contentWidth, 60);
    self.posOrderTableView = [[[FormTableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    posOrderTableView.scrollEnabled = NO;
    posOrderTableView.backgroundColor = [UIColor clearColor];
    posOrderTableView.backgroundView = nil;
    [self.contentView addSubview:posOrderTableView];
    posOrderTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), posOrderTableView.center.y);
    
    [posOrderTableView setDelegateFormList:patternList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    
}

@end
