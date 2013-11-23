//
//  SLBCheckBox.h
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SLBCheckBoxState) {
    SLBCheckBoxStateDeSelected      = 0,
    SLBCheckBoxStateSelected        = 1,
};

@interface SLBCheckBox : UIControl

@property (retain, nonatomic, readonly) UILabel *titleLabel;

@property (assign, nonatomic) BOOL isSelected;

- (void)setTitle:(NSString *)title font:(UIFont *)font;
- (NSString *)title;

- (void)setImage:(UIImage *)image forState:(SLBCheckBoxState)state;
- (UIImage *)imageForState:(SLBCheckBoxState)state;

@end
