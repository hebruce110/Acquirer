//
//  SLBCheckBox.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBCheckBox.h"
#import <QuartzCore/QuartzCore.h>

@interface SLBCheckBox ()

@property (assign, nonatomic) id oldTarget;
@property (assign, nonatomic) SEL oldAction;

@property (retain, nonatomic) UIImageView *checkImgView;

@property (retain, nonatomic) UIImage *selectImg;
@property (retain, nonatomic) UIImage *deSelectImg;

@end

@implementation SLBCheckBox

- (void)dealloc
{
    [_titleLabel release];
    _titleLabel = nil;
    
    [_checkImgView release];
    _checkImgView = nil;
    
    [_selectImg release];
    _selectImg = nil;
    
    [_deSelectImg release];
    _deSelectImg = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectImg = nil;
        _deSelectImg = nil;
        
        _checkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        _titleLabel = [[UILabel alloc] initWithFrame:_checkImgView.bounds];
        
        _checkImgView.backgroundColor = [UIColor clearColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.numberOfLines = 0;
        
        [self addSubview:_checkImgView];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    _checkImgView.frame = CGRectMake(0, 0, bdSize.height, bdSize.height);
    _checkImgView.center = CGPointMake(_checkImgView.bounds.size.width * 0.5f, bdSize.height * 0.5f);
    
    CGFloat tlwd = bdSize.width - _checkImgView.bounds.size.width;
    CGSize lbSize = [_titleLabel.text sizeWithFont:_titleLabel.font forWidth:tlwd lineBreakMode:NSLineBreakByCharWrapping];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_checkImgView.frame), 0, tlwd, MAX(lbSize.height, bdSize.height));
    _titleLabel.center = CGPointMake(_titleLabel.center.x, _checkImgView.center.y);
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if(_isSelected) {
        _checkImgView.image = _selectImg;
    }
    else {
        _checkImgView.image = _deSelectImg;
    }
}

- (void)setTitle:(NSString *)title font:(UIFont *)font
{
    _titleLabel.font = font;
    _titleLabel.text = title;
    [self layoutSubviews];
}

- (NSString *)title
{
    return (_titleLabel.text);
}

- (void)setSelectImg:(UIImage *)selectImg
{
    if(_selectImg) {
        [_selectImg release];
        _selectImg = nil;
    }
    _selectImg = [selectImg retain];
}

- (void)setDeSelectImg:(UIImage *)deSelectImg
{
    if(_deSelectImg) {
        [_deSelectImg release];
        _deSelectImg = nil;
    }
    _deSelectImg = [deSelectImg retain];
}

- (void)setImage:(UIImage *)image forState:(SLBCheckBoxState)state
{
    switch(state) {
        case SLBCheckBoxStateSelected: {
            self.selectImg = image;
        }break;
            
        case SLBCheckBoxStateDeSelected: {
            self.deSelectImg = image;
        }break;
            
        default:
            break;
    }
}

- (UIImage *)imageForState:(SLBCheckBoxState)state
{
    switch(state) {
        case SLBCheckBoxStateSelected: {
            return (_selectImg);
        }break;
            
        case SLBCheckBoxStateDeSelected: {
            return (_deSelectImg);
        }break;
            
        default: {
            return (nil);
        }break;
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    SEL sl = @selector(exchangeAction:forControlEvents:);
    _oldTarget = target;
    _oldAction = action;
    
    [super addTarget:self action:sl forControlEvents:controlEvents];
}

- (void)exchangeAction:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.isSelected = !_isSelected;
    [self sendAction:_oldAction to:_oldTarget forEvent:nil];
}

@end
