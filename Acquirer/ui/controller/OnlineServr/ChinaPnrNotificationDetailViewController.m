//
//  ChinaPnrNotificationDetailViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  汇付动态详情

#import "ChinaPnrNotificationDetailViewController.h"

@implementation ChinaPnrNotificationDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"汇付公告"];
    
}

@end
