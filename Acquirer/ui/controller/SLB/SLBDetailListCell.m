//
//  SLBDetailListCell.m
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBDetailListCell.h"

@implementation SLBDetailListCell

@synthesize icImageView = _icImageView;
@synthesize amountView = _amountView;
@synthesize dateLabel = _dateLabel, typeLabel = _typeLabel;

- (void)dealloc
{
    [_icImageView release];
    _icImageView = nil;
    
    [_amountView release];
    _amountView = nil;
    
    [_dateLabel release];
    _dateLabel = nil;
    
    [_typeLabel release];
    _typeLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icImageView = [[UIImageView alloc] init];
        _amountView = [[SLBAttributedView alloc] init];
        _dateLabel = [[UILabel alloc] init];
        _typeLabel = [[UILabel alloc] init];
        
        _amountView.backgroundColor = [UIColor clearColor];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_icImageView];
        [self.contentView addSubview:_amountView];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_typeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    _icImageView.frame = CGRectMake(0, 0, 16.0f, 16.0f);
    _icImageView.center = CGPointMake(size.height / 3.0f, size.height / 3.0f);
    
    _amountView.frame = CGRectMake(CGRectGetMaxX(_icImageView.frame) + 5.0f, CGRectGetMinY(_icImageView.frame), size.width / 2.0f, 22.0f);
    _amountView.center = CGPointMake(_amountView.center.x, _icImageView.center.y);
    
    _dateLabel.frame = CGRectMake(CGRectGetMinX(_amountView.frame), CGRectGetMaxY(_amountView.frame), CGRectGetWidth(_amountView.frame), 18.0f);
    
    _typeLabel.frame = CGRectMake(0, 0, size.height * 0.85f, size.height);
    _typeLabel.center = CGPointMake(size.width - CGRectGetWidth(_typeLabel.frame), size.height * 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
