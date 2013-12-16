//
//  CustomBadge.m
//  SUBTest
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CustomBadge.h"

@interface CustomBadge ()

@property (retain, nonatomic) NSMutableString *badgeString;

@end

@implementation CustomBadge

- (void)dealloc
{
    [_badgeLabel release];
    _badgeLabel = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_badgeLabel];
        _badgeLabel.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    _badgeLabel.frame = self.bounds;
}

@end
