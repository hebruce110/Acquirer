//
//  SLBServeUserInfoCell.m
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBServeUserInfoCell.h"

@interface SLBServeUserInfoCell ()

@property (retain, nonatomic) UILabel *headerLabel;
@property (retain, nonatomic) UILabel *dtTextLabel;

@end

@implementation SLBServeUserInfoCell

- (void)dealloc
{
    self.headerLabel = nil;
    self.dtTextLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _offset = 10.0f;
        
        _headerLabel = [[UILabel alloc] init];
        _dtTextLabel = [[UILabel alloc] init];
        
        _headerLabel.backgroundColor = _dtTextLabel.backgroundColor = [UIColor clearColor];
        
        _headerLabel.textAlignment = NSTextAlignmentLeft;
        _dtTextLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_headerLabel];
        [self.contentView addSubview:_dtTextLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    
    _headerLabel.frame = CGRectMake(_offset, 0, 100, bdSize.height);
    _dtTextLabel.frame = CGRectMake(CGRectGetMaxX(_headerLabel.frame), 0, bdSize.width - CGRectGetMaxX(_headerLabel.frame) - _offset * 4.0f, bdSize.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (NSString *)title
{
    return (_headerLabel.text);
}

- (void)setTitle:(NSString *)title
{
    [_headerLabel setText:title];
}

- (NSString *)detailTitle
{
    return (_dtTextLabel.text);
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    [_dtTextLabel setText:detailTitle];
}

@end
