//
//  PlainUnitTableCell.m
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "PlainUnitTableCell.h"
#import "Helper.h"

@implementation PlainUnitTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textLabel.font = [UIFont boldSystemFontOfSize:20];
        textLabel.textColor = [Helper amountRedColor];
        
        CGFloat offset = 20;
        CGRect textFrame = textLabel.frame;
        textLabel.frame = CGRectMake(textFrame.origin.x-offset,
                                     textFrame.origin.y,
                                     textFrame.size.width,
                                     textFrame.size.height);
        
        CGRect unitFrame = CGRectMake(textLabel.frame.origin.x+textLabel.frame.size.width+5, 0, 15, DEFAULT_ROW_HEIGHT);
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:unitFrame];
        unitLabel.textAlignment = NSTextAlignmentLeft;
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.font = [UIFont boldSystemFontOfSize:16];
        unitLabel.text = @"元";
        [self addSubview:unitLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
