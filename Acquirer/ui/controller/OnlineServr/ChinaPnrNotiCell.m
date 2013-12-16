//
//  ChinaPnrNotiCell.m
//  SUBTest
//
//  Created by chinaPnr on 13-11-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ChinaPnrNotiCell.h"

@implementation ChinaPnrNotiCell

- (void)dealloc
{
    self.imgView = nil;
    self.dateLabel = nil;
    self.textView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgContentSize = CGSizeMake(30.0f, 30.0f);
        _autoAlignmentVXCenter = NO;
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imgContentSize.width, _imgContentSize.height)];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20.0f)];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 30.0)];
        
        _dateLabel.backgroundColor = _textView.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _textView.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    _imgView.frame = CGRectMake(self.indentationWidth, self.indentationWidth, _imgContentSize.width, _imgContentSize.height);
    if(_autoAlignmentVXCenter) {
        _imgView.center = CGPointMake(_imgView.center.x, bdSize.height / 2.0f);
    }
    
    CGFloat txWidth = bdSize.width - CGRectGetMaxX(_imgView.frame) - self.indentationWidth * 4.0f;
    _dateLabel.frame = CGRectMake(CGRectGetMaxX(_imgView.frame) + self.indentationWidth, CGRectGetMinY(_imgView.frame), txWidth, CGRectGetHeight(_dateLabel.frame));
    
    CGSize txSize = [_textView.text sizeWithFont:_textView.font constrainedToSize:CGSizeMake(txWidth, 5000.0f) lineBreakMode:NSLineBreakByCharWrapping];
    _textView.frame = CGRectMake(CGRectGetMinX(_dateLabel.frame), CGRectGetMaxY(_dateLabel.frame), txWidth, txSize.height + self.indentationWidth);
    
    _textView.editable = NO;
    _textView.pagingEnabled = NO;
    _textView.scrollEnabled = NO;
    _textView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
