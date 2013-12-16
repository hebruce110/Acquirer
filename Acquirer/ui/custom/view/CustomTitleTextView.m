//
//  CustomTitleTextView.m
//  TextViewTest
//
//  Created by soal on 13-11-29.
//  Copyright (c) 2013年 soal. All rights reserved.
//

#import "CustomTitleTextView.h"

@implementation CustomTitleTextView

- (void)dealloc
{
    [_titleLabel release];
    _titleLabel = nil;
    [_dateLabel release];
    _dateLabel = nil;
    [_textView release];
    _textView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _space = 10.0f;
        
        _textView = [[UITextView alloc] init];
        _textView.textColor = [UIColor grayColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.editable = NO;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_textView addSubview:_titleLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.backgroundColor = [UIColor clearColor];
        [_textView addSubview:_dateLabel];
        
        [self addSubview:_textView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    CGSize ctSize = CGSizeMake(bdSize.width - _space * 2.0f, bdSize.height - _space * 2.0f);
    
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:ctSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize dateSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:ctSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat top = titleSize.height + dateSize.height + _space;
    
    _titleLabel.frame = CGRectMake(_space, -top + _space, ctSize.width, titleSize.height);
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), dateSize.height);
    
    _textView.frame = self.bounds;
    _textView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    [_textView scrollRectToVisible:CGRectMake(0, -0.1f, CGRectGetWidth(_textView.frame), CGRectGetHeight(_textView.frame)) animated:NO];
}

- (void)setSpace:(CGFloat)space
{
    _space = space;
    
    [self setNeedsLayout];
}

@end
