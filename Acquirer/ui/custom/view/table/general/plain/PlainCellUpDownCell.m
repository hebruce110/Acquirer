//
//  PlainCellUpDownCell.m
//  Acquirer
//
//  Created by peer on 10/29/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "PlainCellUpDownCell.h"
#import "BaseViewController.h"

@implementation PlainCellUpDownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, 5, 250, 20);
        
        textLabel.font = [UIFont boldSystemFontOfSize:14];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.frame = CGRectMake(titleLabel.frame.origin.x, frameHeighOffset(titleLabel.frame)+5, 250, 20);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
