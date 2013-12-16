//
//  SLBLatestYieldCell.m
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBLatestYieldCell.h"
#import "SLBHelper.h"

@implementation SLBLatestYieldCell

- (void)dealloc
{
    self.imgView = nil;
    self.tlLabel = nil;
    
    [_attView release];
    _attView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _tlLabel = [[UILabel alloc] init];
        _attView = [[SLBAttributedView alloc] init];
        
        _tlLabel.backgroundColor = [UIColor clearColor];
        _attView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_tlLabel];
        [self.contentView addSubview:_attView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    CGFloat space = 10.0f;
    
    CGSize imgSize = _imgView.image.size;
    CGFloat imgHeight = MIN(imgSize.height, bdSize.height);
    _imgView.frame = CGRectMake(space, 0, imgHeight, imgHeight);
    _imgView.center = CGPointMake(_imgView.center.x, bdSize.height * 0.5f);
    
    _tlLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame) + space, 0, 80.0f, bdSize.height);
    
    CGFloat attWidth = bdSize.width - space * 5.0f - CGRectGetMaxX(_tlLabel.frame);
    CGFloat attViewHeight = [NSAttributedString heightOfAttributedString:_attView.attributeString WidthWidth:attWidth];
    _attView.frame = CGRectMake(CGRectGetMaxX(_tlLabel.frame), 0, attWidth, attViewHeight);
    _attView.center = CGPointMake(_attView.center.x, bdSize.height * 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
