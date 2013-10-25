//
//  LoginViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface LoginViewController : BaseViewController <UIGestureRecognizerDelegate>{
    GeneralTableView *loginTableView;
    
    NSMutableArray *patternList;
}

@property (nonatomic, retain) GeneralTableView *loginTableView;

@end
