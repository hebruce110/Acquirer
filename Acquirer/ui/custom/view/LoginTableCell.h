//
//  LoginTableCell.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginCellContent;

@interface LoginTableCell : UITableViewCell <UITextFieldDelegate>{
    UILabel *titleLabel;
    UITextField *contentTextField;
    int maxLEN;
}

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UITextField *contentTextField;

-(void)setContent:(LoginCellContent *)content;

@end

@interface LoginCellContent : NSObject {
    NSString *titleSTR;
    NSString *placeHolderSTR;
    UIKeyboardType keyboardType;
    BOOL secure;
    int maxLength;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *placeHolderSTR;

@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secure;

@property (nonatomic, assign) int maxLength;

@end