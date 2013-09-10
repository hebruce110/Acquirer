//
//  FormCellPattern.m
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "FormCellPattern.h"

@implementation FormCellPattern

@synthesize titleSTR, placeHolderSTR;
@synthesize titleFont, titleColor, titleAlignment;
@synthesize textFont;
@synthesize keyboardType, returnKeyType;
@synthesize secure, maxLength;
@synthesize scrollOffset;

-(void)dealloc{
    [titleSTR release];
    [placeHolderSTR release];
    
    [titleColor release];
    [titleFont release];
    
    [textFont release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        titleSTR = [[NSString stringWithFormat:@""] retain];
        placeHolderSTR = [[NSString stringWithFormat:@""] retain];
        
        titleFont = [[UIFont systemFontOfSize:16] retain];
        titleColor = [[UIColor blackColor] retain];
        titleAlignment = NSTextAlignmentLeft;
        
        textFont = [[UIFont systemFontOfSize:15] retain];
        
        keyboardType = UIKeyboardTypeAlphabet;
        secure = NO;
        //set default maxLen 20
        maxLength = 20;
        
        scrollOffset = CGPointMake(0.0f, 0.0f);
    }
    return self;
}

@end
