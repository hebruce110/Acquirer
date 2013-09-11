//
//  LoginViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class FormTableView;

@interface LoginViewController : BaseViewController <UIGestureRecognizerDelegate>{
    FormTableView *loginTableView;
    
    NSMutableArray *patternList;
}

@property (nonatomic, retain) FormTableView *loginTableView;

@end
