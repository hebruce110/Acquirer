//
//  User.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ACUser.h"

@implementation ACUser

@synthesize corpSTR, opratorSTR, passSTR, state;

-(void)dealloc{
    [corpSTR release];
    [opratorSTR release];
    [passSTR release];
    
    [super dealloc];
}

@end
