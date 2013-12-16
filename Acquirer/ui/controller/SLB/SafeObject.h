//
//  SafeObject.h
//  Acquirer
//
//  Created by SoalHuang on 13-10-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSArray(SafeObject)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSMutableArray(SafeObject)

- (void)safeAddObject:(id)anObject;
- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSDictionary(SafeObject)

//return nsstring or @""
- (id)stringObjectForKey:(id <NSCopying>)key;

//return object or nil
- (id)safeJsonObjForKey:(id <NSCopying>)key;

@end

//-----------------------------------------------------
//-----------------------------------------------------

@interface NSMutableDictionary(SafeObject)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

//-----------------------------------------------------
//-----------------------------------------------------
