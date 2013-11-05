//
//  UserInfomationViewController.h
//  Acquirer
//
//  Created by peer on 11/5/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface UserInfomationViewController : BaseViewController{
    GeneralTableView *userInfoTV;
}

@property (nonatomic, retain) GeneralTableView *userInfoTV;

@end
