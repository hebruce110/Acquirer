
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

-(void)dealloc{
    [titleSTR release];
    [textSTR release];
    
    [super dealloc];
}

@end
