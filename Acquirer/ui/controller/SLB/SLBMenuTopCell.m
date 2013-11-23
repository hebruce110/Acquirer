//
//  SLBMenuTopCell.m
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBMenuTopCell.h"
#import "SLBHelper.h"

@interface SLBMenuTopCell ()

@property (copy, nonatomic, readonly) UIImageView *backgroungImgView;
@property (copy, nonatomic, readonly) SLBAttributedView *attributedView;

@end

@implementation SLBMenuTopCell

- (void)dealloc
{
    [_backgroungImgView release];
    _backgroungImgView = nil;
    
    [_attributedView release];
    _attributedView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgroungImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _attributedView = [[SLBAttributedView alloc] initWithFrame:self.bounds];
        _attributedView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_backgroungImgView];
        [self.contentView addSubview:_attributedView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backgroungImgView.frame = self.bounds;
    
    CGFloat attHeight = [NSAttributedString heightOfAttributedString:_attributedView.attributeString WidthWidth:180.0f];
    _attributedView.frame = CGRectMake(120.0f, 0, 180.0f, attHeight);
    _attributedView.center = CGPointMake(_attributedView.center.x, self.bounds.size.height * 0.5f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelected:NO];
    if(_delegate && [_delegate respondsToSelector:@selector(slbCellDidSelected:)])
    {
        [_delegate slbCellDidSelected:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setBackgroundImage:(UIImage *)bkImage
{
    _backgroungImgView.image = bkImage;
    [self setNeedsLayout];
}

- (UIImage *)backgroundImage
{
    return (_backgroungImgView.image);
}

- (void)setAttributedString:(NSAttributedString *)attrString
{
    [_attributedView setAttributeString:attrString];
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedString
{
    return (_attributedView.attributeString);
}

@end
