//
//  PlainTableCell.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainTableCell.h"
#import "UILabel+Size.h"

@implementation PlainTableCell

@synthesize titleLabel, textLabel;

-(void)dealloc{
    [titleLabel release];
    [textLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat offset = 20;
        CGFloat titleWidth = 180;
        CGRect titleFrame = CGRectMake(offset, 0, titleWidth, DEFAULT_ROW_HEIGHT);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLabel];
        
        CGFloat textWidth = PLAIN_CELL_TEXT_WIDTH;
        CGRect textFrame = CGRectMake(self.bounds.size.width-textWidth-offset, 0, textWidth, self.bounds.size.height);
        textLabel = [[UILabel alloc] initWithFrame:textFrame];
        textLabel.textAlignment = NSTextAlignmentRight;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:16];
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end
