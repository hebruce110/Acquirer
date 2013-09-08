//
//  LoginTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginTableCell.h"
#import "Helper.h"
#import "BaseViewController.h"

@implementation LoginCellContent

@synthesize titleSTR, placeHolderSTR, keyboardType, secure, maxLength;

-(void)dealloc{
    [titleSTR release];
    [placeHolderSTR release];
    [super dealloc];
}
@end


@implementation LoginTableCell

@synthesize delegate;
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
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
        
        CGRect textFrame = CGRectMake(titleFrame.size.width+15, 0, 190, self.bounds.size.height);
        //contentTextField.center = CGPointMake(contentTextField.center.x, titleLabel.center.y);
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

-(void)setContent:(LoginCellContent *)content{
    titleLabel.text = content.titleSTR;
    textField.placeholder = content.placeHolderSTR;
    textField.keyboardType = content.keyboardType;
    if (content.secure) {
        textField.secureTextEntry = YES;
    }
    maxLEN = content.maxLength;
}

-(void)adjustForActivateViewController{
    CGFloat titleWidth = [Helper getLabelWidth:titleLabel.text setFont:titleLabel.font setHeight:titleLabel.bounds.size.height];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x-2, titleLabel.frame.origin.y, titleWidth, titleLabel.bounds.size.height);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    
    textField.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.bounds.size.width,
                                 textField.frame.origin.y, self.bounds.size.width-titleLabel.frame.origin.x-titleLabel.bounds.size.width-10,
                                 textField.bounds.size.height);
    textField.font = [UIFont systemFontOfSize:15];
    
}

#pragma mark UITextFieldDelegate Method

-(void)textFieldDidBeginEditing:(UITextField *)_textField{
    if (delegate) {
        [delegate adjustForTextFieldDidBeginEditing:_textField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)_textField{
    if (delegate) {
        [delegate adjustForTextFieldDidEndEditing:_textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    
    if (delegate) {
        return [delegate adjustForTextFieldShouldReturn:_textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)_textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //input del
    if ([Helper stringNullOrEmpty:string]) {
        return YES;
    }
    
    if (_textField.text.length >= maxLEN) {
        return NO;
    }
    return YES;
}

@end
