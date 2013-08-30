//
//  TestViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-8-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TestViewController.h"
#import "NSNotificationCenter+CP.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(0, 0, 80, 30);
    [btn1 setTitle:@"错误效果" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1;
    [self.contentView addSubview:btn1];
    btn1.center = CGPointMake(contentView.center.x, contentView.center.y-60);
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(0, 0, 80, 30);
    [btn2 setTitle:@"提示效果" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 2;
    [self.contentView addSubview:btn2];
    btn2.center = CGPointMake(contentView.center.x, contentView.center.y);
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(0, 0, 80, 30);
    [btn3 setTitle:@"成功效果" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 3;
    [self.contentView addSubview:btn3];
    btn3.center = CGPointMake(contentView.center.x, contentView.center.y+60);
    
}

-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"..." notifyType:NOTIFICATION_TYPE_ERROR];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"..." notifyType:NOTIFICATION_TYPE_WARNING];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"..." notifyType:NOTIFICATION_TYPE_SUCCESS];
            break;
            
        default:
            break;
    }
}

@end
