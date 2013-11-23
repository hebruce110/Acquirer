//
//  SLBUserNotiDocViewController.h
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_OPTIONS(NSUInteger, SLBAgreementType)
{
    SLBUserNotiTypeAuthorization,  //生利宝授权协议
    SLBUserNotiTypeServe,          //生利宝服务协议
    SLBUserNotiTypeIntroduction,   //生利宝介绍及收益说明
};

@interface SLBUserNotiDocViewController : BaseViewController

@property (assign, nonatomic) SLBAgreementType agreementType;

@end
