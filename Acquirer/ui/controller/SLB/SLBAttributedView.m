//
//  SLBAttributedView.m
//  Acquirer
//
//  Created by Soal on 13-10-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBAttributedView.h"

@interface SLBAttributedView ()

@property (retain, nonatomic) NSMutableAttributedString *attributedText;

@end

@implementation SLBAttributedView

- (void)dealloc
{    
    self.attributedText = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _attributedText = nil;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAttributeString:(NSAttributedString *)attributeString
{
    if(_attributedText) {
        [_attributedText release];
        _attributedText = nil;
    }
    _attributedText = [attributeString copy];
    
    if(_attributedText) {
        [self setNeedsDisplay];
    }
}

- (NSAttributedString *)attributeString
{
    return (_attributedText);
}

- (void)drawRect:(CGRect)rect
{
    if(_attributedText) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        
        CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.0f, -1.0f));
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        CFRelease(framesetter);
        
        CTFrameDraw(frame, context);
        CFRelease(frame);
        
        UIGraphicsPopContext();
    }
    
    [super drawRect:rect];
}

@end
