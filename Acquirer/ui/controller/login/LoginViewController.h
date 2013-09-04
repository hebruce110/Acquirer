//
//  LoginViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    UITableView *loginTableView;
    
    NSMutableArray *contentList;
}

@property (nonatomic, retain) UITableView *loginTableView;

@end
