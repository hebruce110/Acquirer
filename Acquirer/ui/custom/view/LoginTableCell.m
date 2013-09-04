//
//  LoginTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginTableCell.h"

@implementation LoginCellContent

@synthesize titleSTR, placeHolderSTR, keyboardType, secure, maxLength;

-(void)dealloc{
    [titleSTR release];
    [placeHolderSTR release];
    [super dealloc];
}
@end

@implementation LoginTableCell

@synthesize titleLabel, contentTextField;

-(void)dealloc{
    [titleLabel release];
    [contentTextField release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect titleFrame = CGRectMake(20, 0, 100, 30);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.center = CGPointMake(titleLabel.center.x, CGRectGetMidY(self.bounds));
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
        
        CGRect contentFrame = CGRectMake(titleFrame.size.width+15, 0, 170, self.bounds.size.height);
        //contentTextField.center = CGPointMake(contentTextField.center.x, titleLabel.center.y);
        contentTextField = [[UITextField alloc] initWithFrame:contentFrame];
        [contentTextField setKeyboardType:UIKeyboardTypeAlphabet];
        [contentTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        contentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTextField.returnKeyType = UIReturnKeyDone;
        contentTextField.delegate = self;
        [self addSubview:contentTextField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    if (selected == YES) {
        [contentTextField becomeFirstResponder];
    }else{
        [contentTextField resignFirstResponder];
    }
}

-(void)setContent:(LoginCellContent *)content{
    titleLabel.text = content.titleSTR;
    contentTextField.placeholder = content.placeHolderSTR;
    contentTextField.keyboardType = content.keyboardType;
    if (content.secure) {
        contentTextField.secureTextEntry = YES;
    }
    maxLEN = content.maxLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [contentTextField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= maxLEN) {
        return NO;
    }
    return YES;
}

@end
