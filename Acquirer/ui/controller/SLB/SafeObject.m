//
//  SafeObject.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SafeObject.h"

@implementation NSArray(SafeObject)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if(index > self.count - 1)
    {
        NSLog(@"-- array objectAtIndex:out of array range ---");
        return (nil);
    }
    return ([self objectAtIndex:index]);
}

@end

//-----------------------------------------------------
//-----------------------------------------------------

@implementation NSMutableArray(SafeObject)

- (void)safeAddObject:(id)anObject
{
    if(!anObject)
    {
        NSLog(@"--- addObject:object must not nil ---");
        return;
    }
    [self addObject:anObject];
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if(index > self.count - 1)
    {
        NSLog(@"--- insertObject:atIndex:out of array range ---");
        return;
    }
    
    if(!anObject)
    {
        NSLog(@"--- insertObject:atIndex:object must not nil ---");
        return;
    }
    [self insertObject:anObject atIndex:index];
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
    if(index > self.count - 1)
    {
        NSLog(@"--- removeObjectAtIndex:out of array range ---");
        return;
    }
    
    [self removeObjectAtIndex:index];
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if(index > self.count - 1)
    {
        NSLog(@"--- replaceObjectAtIndex:atIndex:out of array range ---");
        return;
    }
    
    if(!anObject)
    {
        NSLog(@"--- replaceObjectAtIndex:atIndex:object must not nil ---");
        return;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
}

@end


#define checkNull(__X__) (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation NSDictionary(SafeObject)

- (id)safeObjectForKey:(id)key
{
    return (checkNull([self objectForKey:key]));
}

- (id)safeJsonObjForKey:(id)key
{
    return (([self objectForKey:key] == [NSNull null]) ? (nil) : ([self objectForKey:key]));
}

@end


@implementation NSMutableDictionary(SafeObject)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(!aKey)
    {
        NSLog(@"--- setObject:forKey: key must not nil");
    }
    else if(!anObject)
    {
        NSLog(@"--- setObject:forKey: object must not nil");
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end

