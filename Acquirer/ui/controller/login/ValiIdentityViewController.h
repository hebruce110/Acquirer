//
//  ValiIdentityViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "GeneralTableView.h"

@interface ValiIdentityViewController : BaseViewController <UIGestureRecognizerDelegate>{
    UIScrollView *bgScrollView;
    
    GeneralTableView *posOrderTableView;
    GeneralTableView *captchaTableView;
    
    UIImageView *authImgView;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;
@property (nonatomic, retain) GeneralTableView *posOrderTableView;
@property (nonatomic, retain) GeneralTableView *captchaTableView;
@property (nonatomic, retain) UIImageView *authImgView;

-(void)refreshAuthImgView:(NSData *)imgData;

@end
