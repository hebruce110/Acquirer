//
//  ChatBubbleView.m
//  Acquirer
//
//  Created by peer on 11/19/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatBubbleView.h"

const CGFloat VertPadding = 4;
const CGFloat HorzPadding = 4;

const CGFloat TextLeftMargin = 15;
const CGFloat TextRightMargin = 15;
const CGFloat TextTopMargin = 10;
const CGFloat TextBottomMargin = 11;

const CGFloat MinBubbleWidth = 50;
const CGFloat MinBubbleHeight = 40;

const CGFloat WrapWidth = 200;

static UIFont *font;

@implementation ChatBubbleView

@synthesize textSTR, bubbleType;

+(void)initialize{
    if (self == [ChatBubbleView class]) {
        font = [[UIFont boldSystemFontOfSize:16] retain];
    }
}

-(void)dealloc{
    [textSTR release];
    
    [super dealloc];
}

+(CGSize)sizeForText:(NSString *)text{
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(WrapWidth, 999)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize bubbleSize;
    bubbleSize.width = textSize.width + TextLeftMargin + TextRightMargin;
    bubbleSize.height = textSize.height + TextTopMargin + TextBottomMargin;
    
    if (bubbleSize.width < MinBubbleWidth) {
        bubbleSize.width = MinBubbleWidth;
    }
    
    if (bubbleSize.height < MinBubbleHeight) {
        bubbleSize.height = MinBubbleHeight;
    }
    
    bubbleSize.width += HorzPadding * 2;
    bubbleSize.height += VertPadding * 2;
    
    return bubbleSize;
}

//气泡效果处理
-(void)drawRect:(CGRect)rect{
    [self.backgroundColor setFill];
    UIRectFill(rect);
    
    CGRect bubbleRect = CGRectInset(self.bounds, VertPadding, HorzPadding);
    
    CGRect textRect;
    textRect.origin.y = bubbleRect.origin.y + TextTopMargin;
    textRect.size.width = bubbleRect.size.width - TextLeftMargin - TextRightMargin;
    textRect.size.height = bubbleRect.size.height - TextTopMargin - TextBottomMargin;
    
    UIImage *bubbleImg = nil;
    if (bubbleType == BubbleTypeLeft) {
        bubbleImg = [[UIImage imageNamed:@"bubble_white.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:19];
        textRect.origin.x = bubbleRect.origin.x + TextLeftMargin;
    }else if (bubbleType == BubbleTypeRight){
        bubbleImg = [[UIImage imageNamed:@"bubble_green.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:19];
        textRect.origin.x = bubbleRect.origin.x + TextRightMargin;
    }
    [bubbleImg drawInRect:rect];
    
    if (bubbleType == BubbleTypeLeft) {
        [[UIColor blackColor] set];
    }else if (bubbleType == BubbleTypeRight){
        [[UIColor whiteColor] set];
    }
    [textSTR drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
}

-(void)setText:(NSString *)newText bubbleType:(BubbleType)newBubbleType{
    self.textSTR = newText;
    bubbleType = newBubbleType;
    [self setNeedsDisplay];
}

@end























