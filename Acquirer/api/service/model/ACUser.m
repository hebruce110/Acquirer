//
//  User.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ACUser.h"

@implementation ACUser

@synthesize instSTR, opratorSTR, passSTR;
@synthesize opratorNameSTR, mobileSTR;
@synthesize state;
@synthesize devList;

-(void)deepCopyDevList:(NSArray *)list{
    self.devList = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *devId in list) {
        [devList addObject:devId];
    }
}

-(void)dealloc{
    [instSTR release];
    [opratorSTR release];
    [passSTR release];
    
    [opratorNameSTR release];
    [mobileSTR release];
    [devList release];
    
    [super dealloc];
}

@end
