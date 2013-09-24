//
//  FormCellPattern.m
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "FormCellPattern.h"
#import "FormTableCell.h"

@implementation FormCellPattern

@synthesize titleSTR, placeHolderSTR, textSTR;
@synthesize titleFont, titleColor, titleAlignment;
@synthesize textFont;
@synthesize keyboardType, returnKeyType;
@synthesize secure, maxLength;
@synthesize scrollOffset;
@synthesize formCellClass;

-(void)dealloc{
    [titleSTR release];
    [placeHolderSTR release];
    [textSTR release];
    
    [titleColor release];
    [titleFont release];
    
    [textFont release];
    
    [super dealloc];
}

//default configuration param
-(id)init{
    self = [super init];
    if (self != nil) {
        titleSTR = [[NSString stringWithFormat:@""] retain];
        placeHolderSTR = [[NSString stringWithFormat:@""] retain];
        textSTR = [[NSString stringWithFormat:@""] retain];
        
        titleFont = [[UIFont systemFontOfSize:16] retain];
        titleColor = [[UIColor blackColor] retain];
        titleAlignment = NSTextAlignmentLeft;
        
        textFont = [[UIFont systemFontOfSize:17] retain];
        
        keyboardType = UIKeyboardTypeAlphabet;
        secure = NO;
        //set default maxLen 20
        maxLength = 20;
        
        scrollOffset = CGPointMake(0.0f, 0.0f);
        
        formCellClass = [FormTableCell class];
    }
    return self;
}

@end
