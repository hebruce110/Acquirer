//
//  LineBreakTableCell.m
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "LineBreakTableCell.h"

@implementation LineBreakTableCell

@synthesize titleLabel;

-(void)dealloc{
    [titleLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat offset = 20;
        CGFloat titleWidth = self.bounds.size.width-40;
        CGRect titleFrame = CGRectMake(offset, 0, titleWidth, self.bounds.size.height);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    titleLabel.center = CGPointMake(titleLabel.center.x, CGRectGetMidY(self.bounds));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
