//
//  SLBMenuAttributedCell.m
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBMenuAttributedCell.h"
#import "SLBAttributedView.h"
#import "SLBHelper.h"

@interface SLBMenuAttributedCell ()

@property (retain, nonatomic) SLBAttributedView *attributedTitleView;
@property (retain, nonatomic) SLBAttributedView *attributedTextView;

@end


@implementation SLBMenuAttributedCell

- (void)dealloc
{
    self.attributedTitleView = nil;
    self.attributedTextView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.hidden = YES;
        _vxAlignment = alinmentToCenter;
        _attributedTitleView = [[SLBAttributedView alloc] init];
        _attributedTextView = [[SLBAttributedView alloc] init];
        
        _attributedTitleView.backgroundColor = [UIColor clearColor];
        _attributedTextView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_attributedTitleView];
        [self.contentView addSubview:_attributedTextView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bdSize = self.bounds.size;
    CGFloat toLeft = 10.0f;
    CGFloat titleWidth = bdSize.width * 0.5f;
    CGFloat textWidth = bdSize.width - titleWidth - toLeft * 4.0f;

    CGFloat titleHeight = [NSAttributedString heightOfAttributedString:_attributedTitleView.attributeString WidthWidth:titleWidth];
    _attributedTitleView.frame = CGRectMake(0, 0, titleWidth, titleHeight);
    _attributedTitleView.center = CGPointMake(toLeft + titleWidth / 2.0f, bdSize.height / 2.0f);
    
    CGFloat textHeight = [NSAttributedString heightOfAttributedString:_attributedTextView.attributeString WidthWidth:textWidth];
    _attributedTextView.frame = CGRectMake(CGRectGetMinX(_attributedTitleView.frame) + titleWidth, CGRectGetMinY(_attributedTitleView.frame), textWidth, textHeight);
    
    switch(_vxAlignment) {
        case alinmentToCenter: {
            _attributedTextView.center = CGPointMake(_attributedTextView.center.x, bdSize.height / 2.0f);
        }break;
            
        case alinmentToBottom: {
            _attributedTextView.center = CGPointMake(_attributedTextView.center.x, CGRectGetMinY(_attributedTitleView.frame) + (CGRectGetHeight(_attributedTitleView.frame) - CGRectGetHeight(_attributedTextView.frame)));
        }break;
          
        case alinmentToTop:
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setAttributedTitle:(NSAttributedString *)attrTitle
{
    NSMutableAttributedString *mtlAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attrTitle];
    
    CTParagraphStyleSetting alignmentSetting;
    CTTextAlignment alg = kCTTextAlignmentLeft;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.value = &alg;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting spaceSetting;
    CGFloat space = 1.0f;
    spaceSetting.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    spaceSetting.value = &space;
    spaceSetting.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {alignmentSetting, spaceSetting};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
    
    [mtlAttributedString beginEditing];
    [mtlAttributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:NSMakeRange(0, mtlAttributedString.length)];
    [mtlAttributedString endEditing];
    
    CFRelease(paragraphStyle);
    
    [_attributedTitleView setAttributeString:mtlAttributedString];
    [mtlAttributedString release];
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedTitle
{
    return ([_attributedTitleView attributeString]);
}

- (void)setAttributedText:(NSAttributedString *)attrText
{
    NSMutableAttributedString *mtlAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attrText];
    
    CTParagraphStyleSetting alignmentSetting;
    CTTextAlignment alg = kCTTextAlignmentRight;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.value = &alg;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting settings[] = {alignmentSetting};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);
    
    [mtlAttributedString beginEditing];
    [mtlAttributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:NSMakeRange(0, mtlAttributedString.length)];
    [mtlAttributedString endEditing];
    
    CFRelease(paragraphStyle);
    
    [_attributedTextView setAttributeString:mtlAttributedString];
    [mtlAttributedString release];
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedText
{
    return ([_attributedTextView attributeString]);
}

@end
