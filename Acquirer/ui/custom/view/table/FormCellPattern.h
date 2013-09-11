//
//  FormCellPattern.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormCellPattern : NSObject{
    NSString *titleSTR;
    NSString *placeHolderSTR;
    
    UIFont *titleFont;
    UIColor *titleColor;
    NSTextAlignment titleAlignment;
    
    UIFont *textFont;
    
    UIKeyboardType keyboardType;
    UIReturnKeyType returnKeyType;
    
    BOOL secure;
    int maxLength;
    
    CGPoint scrollOffset;
    
    Class formCellClass;
}

@property (nonatomic, copy) NSString *titleSTR;
@property (nonatomic, copy) NSString *placeHolderSTR;

@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

@property (nonatomic, retain) UIFont *textFont;

@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@property (nonatomic, assign) BOOL secure;
@property (nonatomic, assign) int maxLength;

@property (nonatomic, assign) CGPoint scrollOffset;

@property (nonatomic, assign) Class formCellClass;

@end
