//
//  User.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ACUser.h"

@implementation ACUser

@synthesize instSTR, opratorSTR, passSTR, latestYield, agentSlbFlag, acctStat;
@synthesize opratorNameSTR, mobileSTR;
@synthesize state;
@synthesize devList;

-(void)dealloc{
    [instSTR release];
    [opratorSTR release];
    [passSTR release];
    
    [latestYield release];
    latestYield = nil;
    [agentSlbFlag release];
    agentSlbFlag = nil;
    [acctStat release];
    acctStat = nil;
    
    [opratorNameSTR release];
    [mobileSTR release];
    [devList release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        latestYield = nil;
        agentSlbFlag = nil;
        acctStat = nil;
    }
    return (self);
}

-(void)deepCopyDevList:(NSArray *)list{
    self.devList = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *devId in list) {
        [devList addObject:devId];
    }
}

@end
