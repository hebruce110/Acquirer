//
//  CTView.m
//  CoreTextMagazine
//
//  Created by Marin Todorov on 8/11/11.
//  Copyright 2011 Marin Todorov. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "MarkupParser.h"
#import "CTColumnView.h"
#import "SafeObject.h"

@implementation CTView

@synthesize attString;
@synthesize frames;
@synthesize images;

-(void)dealloc
{
    self.attString = nil;
    self.frames = nil;
    self.images = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.attString = nil;
        self.frames = nil;
        self.images = nil;
    }
    return self;
}

- (void)buildFrames
{
    self.pagingEnabled = NO;
    self.scrollEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect textFrame = CGRectMake(0, 0, self.contentSize.width, 2000.0f);
    CGPathAddRect(path, NULL, textFrame);
    
    CFRelease(path);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    CGFloat textPos = 0;
    NSUInteger columnIndex = 0;
    CGFloat totalHeight = self.contentInset.bottom;
    
    while (textPos < [attString length]) {
        CGPoint colOffset = CGPointMake(frameXOffset, frameYOffset + 2.0f * columnIndex * frameYOffset + columnIndex * textFrame.size.height);
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width, textFrame.size.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
        
        CGRect contextViewFrame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height);
        CTColumnView* contentView = [[CTColumnView alloc] initWithFrame: contextViewFrame];
        contentView.backgroundColor = [UIColor clearColor];
        [contentView setCTFrame:(id)frame];
        //不需要处理图片
        //[self attachImagesWithFrame:frame inColumnView: contentView];
        [self.frames addObject: (id)frame];
        [self addSubview: contentView];
        [contentView release];
        
        textPos += visibleRange.length;
        
        NSArray *linesArray = (NSArray *)CTFrameGetLines(frame);
        
        CGPoint origins[[linesArray count]];
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
        
        CGFloat line_y = (CGFloat) origins[[linesArray count] -1].y;
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CTLineRef line = (CTLineRef) [linesArray safeObjectAtIndex:[linesArray count] - 1];
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        totalHeight += (textFrame.size.height - line_y + (CGFloat)descent + 1);
        
        CFRelease(frame);
        CFRelease(path);
        
        columnIndex += 1;
    }
    
    CFRelease(framesetter);
    
    self.contentSize = CGSizeMake(self.bounds.size.width, totalHeight);
}

-(void)setAttString:(NSAttributedString *)string withImages:(NSArray*)imgs
{
    self.attString = string;
    self.images = imgs;
}

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col
{
    NSArray *lines = (NSArray *)CTFrameGetLines(f);
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins);
    
    if(!self.images || self.images.count < 1) {
        return;
    }
    int imgIndex = 0;
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    CFRange frameRange = CTFrameGetVisibleStringRange(f);
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) {
            return;
        }
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) {
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) {
	            CGRect runBounds = CGRectZero;
	            CGFloat ascent = 0;
	            CGFloat descent = 0;
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	            runBounds.origin.x = origins[lineIndex].x + self.frame.origin.x + xOffset + frameXOffset;
	            runBounds.origin.y = origins[lineIndex].y + self.frame.origin.y + frameYOffset;
	            runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x - frameXOffset - self.contentOffset.x, colRect.origin.y - frameYOffset - self.frame.origin.y);
                [col.images addObject:
                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
                 ]; 
                
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

@end
