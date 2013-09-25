
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
@synthesize cellStyle;

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
    
    [super dealloc];
}

@end
