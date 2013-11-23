//
//  SLBUser.m
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBUser.h"

@interface SLBUser ()

@property (retain, nonatomic) NSMutableDictionary *slbUserInfo;

@end

@implementation SLBUser

- (void)dealloc
{
    [_slbUserInfo release];
    _slbUserInfo = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self)
    {        
        _slbUserInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return (self);
}

- (id)objectForKey:(id)aKey
{
    return ([_slbUserInfo objectForKey:aKey]);
}

- (id)safeObjectForKey:(id)aKey
{
    id anObj = [_slbUserInfo objectForKey:aKey];
    if(!anObj || anObj == [NSNull null])
    {
        return(@"");
    }
    
    return (anObj);
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject && aKey)
    {
        [_slbUserInfo setObject:anObject forKey:aKey];
    }
}

- (void)logAll
{
    NSLog(@"### slb user info:%@", _slbUserInfo);
}

@end
