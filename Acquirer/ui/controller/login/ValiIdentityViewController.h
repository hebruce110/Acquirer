//
//  ValiIdentityViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "FormTableView.h"

@interface ValiIdentityViewController : BaseViewController <UIGestureRecognizerDelegate>{
    UIScrollView *bgScrollView;
    
    FormTableView *posOrderTableView;
    FormTableView *captchaTableView;
    
    UIImageView *authImgView;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;
@property (nonatomic, retain) FormTableView *posOrderTableView;
@property (nonatomic, retain) FormTableView *captchaTableView;
@property (nonatomic, retain) UIImageView *authImgView;

-(void)refreshAuthImgView:(NSData *)imgData;

@end
