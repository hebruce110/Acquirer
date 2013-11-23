//
//  NoticeViewController.h
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeService.h"

@interface NoticeViewController : BaseViewController

@property (assign, nonatomic) MessageFlag msgFlag;
@property (assign, nonatomic) BOOL isNeedRefresh;

@end
