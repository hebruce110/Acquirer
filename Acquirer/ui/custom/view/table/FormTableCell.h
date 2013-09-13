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
    
    //标题
    UILabel *titleLabel;
    //输入框
    UITextField *textField;
    //最大输入长度
    int maxLEN;
    //偏移量
    CGPoint offset;
}

@property (nonatomic, assign) BaseViewController *CTRLdelegate;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UITextField *textField;

-(void)setFormCellPattern:(FormCellPattern *)pattern;

//layout title and text frame for custom form
-(void)adjustLayoutForViewController;

@end


