//
//  TransHomeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TransHomeViewController.h"

@interface TransHomeViewController ()

@end

@implementation TransHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"刷卡交易"];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *lunchFlag = [Helper getValueByKey:ACQUIRER_LAUNCH_LOGIN_FLAG];
    if (lunchFlag && [lunchFlag isEqualToString:NSSTRING_YES]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUIRE_USER_LOGIN object:nil];
        [Helper saveValue:NSSTRING_NO forKey:ACQUIRER_LAUNCH_LOGIN_FLAG];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
