//
//  ReviseMobileViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-13.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface ReviseMobileViewController : BaseViewController <UIGestureRecognizerDelegate>{
    NSString *pnrDevIdSTR;
    
    GeneralTableView *mobileTableView;
    UIButton *submitBtn;
}

@property (nonatomic, retain) UIButton *submitBtn;
@property (nonatomic, copy) NSString *pnrDevIdSTR;
@property (nonatomic, retain) GeneralTableView *mobileTableView;

@end
