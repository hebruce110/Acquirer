//
//  POSReportFormCell.m
//  SUBTest
//
//  Created by chinaPnr on 13-11-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "POSReportFormCell.h"

@implementation POSReportFormCell

- (void)dealloc
{
    self.imgView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16.0f, 16.0f)];
        _imgView.image = [UIImage imageNamed:@"badge_mes_new"];
        [self.contentView addSubview:_imgView];
        
        _imgView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = [self.textLabel.text sizeWithFont:self.textLabel.font forWidth:320.0f lineBreakMode:NSLineBreakByCharWrapping];
    
    _imgView.center = CGPointMake(sz.width + CGRectGetWidth(self.imgView.frame) / 2.0f + self.indentationWidth + 5.0f, self.bounds.size.height / 2.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
