
//
//  PlainContent.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainContent.h"

@implementation PlainContent

@synthesize titleSTR, textSTR;
@synthesize imgNameSTR;
@synthesize cellStyle;
@synthesize jumpClass;

-(id)init{
    self = [super init];
    if (self) {
        cellStyle = Cell_Plain_Style_Plain;
    }
    return self;
}

-(void)dealloc{
    [titleSTR release];
    [textSTR release];
    [imgNameSTR release];
    
    [super dealloc];
}

@end
