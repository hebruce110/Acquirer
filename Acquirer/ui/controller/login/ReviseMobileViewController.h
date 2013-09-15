//
//  ReviseMobileViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-13.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class FormTableView;

@interface ReviseMobileViewController : BaseViewController <UIGestureRecognizerDelegate>{
    NSString *pnrDevIdSTR;
    
    FormTableView *mobileTableView;
    UIButton *submitBtn;
}

@property (nonatomic, retain) UIButton *submitBtn;
@property (nonatomic, copy) NSString *pnrDevIdSTR;
@property (nonatomic, retain) FormTableView *mobileTableView;

@end
