//
//  Standard TitleTextTableCell
//
//  TTSTDTableCell.m
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "FormTableCell.h"
#import "BaseViewController.h"
#import "FormCellPattern.h"

@implementation FormTableCell

@synthesize CTRLdelegate;
@synthesize titleLabel, textField;

-(void)dealloc{
    [titleLabel release];
    [textField release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect titleFrame = CGRectMake(20, 0, 100, 30);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.center = CGPointMake(titleLabel.center.x, CGRectGetMidY(self.bounds));
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLabel];
        
        CGRect textFrame = CGRectMake(titleFrame.size.width+15, 0, 190, self.bounds.size.height);
        textField = [[UITextField alloc] initWithFrame:textFrame];
        [textField setKeyboardType:UIKeyboardTypeAlphabet];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont systemFontOfSize:15];
        textField.delegate = self;
        [self addSubview:textField];
        
        //set default textinput LEN 20
        maxLEN = 20;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected == YES) {
        [textField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
}

-(void)setFormCellPattern:(FormCellPattern *)pattern{
    titleLabel.text = pattern.titleSTR;
    textField.placeholder = pattern.placeHolderSTR;
    
    [self adjustLayoutForViewController];
    
    titleLabel.font = pattern.titleFont;
    titleLabel.textColor = pattern.titleColor;
    titleLabel.textAlignment = pattern.titleAlignment;
    
    textField.font = pattern.textFont;
    textField.keyboardType = pattern.keyboardType;
    textField.returnKeyType = pattern.returnKeyType;
    textField.text = pattern.textSTR;
    
    if (pattern.secure) {
        textField.secureTextEntry = YES;
    }
    
    maxLEN = pattern.maxLength;
    
    offset = pattern.scrollOffset;
}

//got the real cell width demension after layoutsubviews
-(void)layoutSubviews{
    [super layoutSubviews];
    [self adjustLayoutForViewController];
}

-(void)adjustLayoutForViewController{
    CGFloat titleWidth = [Helper getLabelWidth:titleLabel.text setFont:titleLabel.font setHeight:titleLabel.bounds.size.height];
    
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleWidth, titleLabel.bounds.size.height);
    
    textField.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width,
                                 textField.frame.origin.y,
                                 self.bounds.size.width-titleLabel.frame.origin.x-titleLabel.bounds.size.width-10,
                                 textField.bounds.size.height);
}


#pragma mark UITextFieldDelegate Method

-(void)textFieldDidBeginEditing:(UITextField *)_textField{
    if (CTRLdelegate) {
        [CTRLdelegate adjustForTextFieldDidBeginEditing:_textField contentOffset:offset];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)_textField{
    if (CTRLdelegate) {
        [CTRLdelegate adjustForTextFieldDidEndEditing:_textField contentOffset:offset];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)_textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //avoid when(textlen == maxLEN), del doesn't work
    if ([Helper stringNullOrEmpty:string]) {
        return YES;
    }
    
    if (_textField.text.length >= maxLEN) {
        return NO;
    }
    return YES;
}

@end
