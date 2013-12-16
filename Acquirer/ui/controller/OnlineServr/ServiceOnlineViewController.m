//
//  ServiceOnlineViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  在线客服

#import "ServiceOnlineViewController.h"

@interface ServiceOnlineViewController ()

@end

@implementation ServiceOnlineViewController

- (void)dealloc
{
    
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
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"在线客服"];
    
    [MessageNumberData setMessageCount:0 report:YES];
}

@end
