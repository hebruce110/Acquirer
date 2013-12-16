//
//  SLBUser.m
//  Acquirer
//
//  Created by Soal on 13-10-29.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBUser.h"
#import "SafeObject.h"

@interface SLBUser ()

@property (retain, nonatomic) NSMutableDictionary *slbUserInfo;

@end

@implementation SLBUser

- (void)dealloc
{
    self.slbUserInfo = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self) {
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
    return ([_slbUserInfo stringObjectForKey:aKey]);
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(anObject && aKey) {
        [_slbUserInfo setObject:anObject forKey:aKey];
    }
}

- (NSString *)description
{
    return ([NSString stringWithFormat:@"slb user info:\n%@", _slbUserInfo]);
}

@end
