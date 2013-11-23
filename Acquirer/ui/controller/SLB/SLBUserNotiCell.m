//
//  SLBUserNotiCell.m
//  Acquirer
//
//  Created by Soal on 13-10-28.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBUserNotiCell.h"

@implementation SLBUserNotiCell

- (void)dealloc
{
    [_attributedView release];
    _attributedView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _attributedView = [[SLBAttributedView alloc] init];
        _attributedView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_attributedView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _attributedView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end

