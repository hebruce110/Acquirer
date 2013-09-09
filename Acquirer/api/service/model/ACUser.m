//
//  User.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ACUser.h"

@implementation ACUser

@synthesize instSTR, opratorSTR, opratorNameSTR, passSTR, state;

-(void)dealloc{
    [instSTR release];
    [opratorSTR release];
    [opratorNameSTR release];
    [passSTR release];
    
    [super dealloc];
}

@end
