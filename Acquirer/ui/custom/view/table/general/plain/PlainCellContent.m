
//
//  PlainContent.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainCellContent.h"

@implementation PlainCellContent

@synthesize titleSTR, textSTR;
@synthesize imgNameSTR;
@synthesize jumpClass;
@synthesize bgColor;

-(id)init{
    self = [super init];
    if (self) {
        cellStyle = Cell_Style_Plain;
    }
    return self;
}

-(void)dealloc{
    [titleSTR release];
    [textSTR release];
    [imgNameSTR release];
    [bgColor release];
    
    [super dealloc];
}

@end
