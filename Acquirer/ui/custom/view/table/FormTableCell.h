//
//  TTSTDTableCell.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;
@class FormCellPattern;

@interface FormTableCell : UITableViewCell <UITextFieldDelegate>{
    BaseViewController *CTRLdelegate;
    
    UILabel *titleLabel;
    UITextField *textField;
    
    int maxLEN;
    
    CGPoint offset;
}

@property (nonatomic, assign) BaseViewController *CTRLdelegate;

-(void)setFormCellPattern:(FormCellPattern *)pattern;

//layout title and text frame for custom form
-(void)adjustLayoutForViewController;

@end


