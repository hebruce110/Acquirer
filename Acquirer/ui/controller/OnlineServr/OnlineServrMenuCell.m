//
//  OnlineServrMenuCell.m
//  Acquirer
//
//  Created by soal on 13-11-19.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "OnlineServrMenuCell.h"

@implementation OnlineServrMenuCell

- (void)dealloc
{
    self.dateLabel = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    _dateLabel.frame = CGRectMake(0, 0, bdSize.width / 4.0f, bdSize.height);
    _dateLabel.center = CGPointMake(bdSize.width - CGRectGetWidth(_dateLabel.frame) / 2.0f - self.indentationWidth * 5.0f, self.textLabel.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
