//
//  PlainLineBreakTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainLineBreakTableCell.h"

@implementation PlainLineBreakTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textLabel.frame = CGRectMake(30, 25, 260, 60);
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.lineBreakMode = YES;
        textLabel.numberOfLines = 3;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
