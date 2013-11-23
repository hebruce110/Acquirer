//
//  NoticeDetailViewController.h
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "NoticeService.h"

@interface NoticeDetailViewController : BaseViewController

@property (assign, nonatomic) MessageFlag msgFlag;
@property (retain, nonatomic) NSString *idCountStr;

@end
