//
//  CPSqlQuery.h
//  Acquirer
//
//  Created by peer on 11/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPSqlQuery : NSObject {
    int mLastStepResult;
    struct sqlite3* mDBHandle;
    struct sqlite3_stmt* mCompiledStatement;
    NSString* mQueryString;
    NSArray* mColumnIndex;
}

+(id) queryWithDb:(struct sqlite3*) dbHandle query:(NSString*) query;
+(id) queryWithDb:(struct sqlite3*) dbHandle query:(NSString*) query doAssert:(BOOL)doAssert;
-(id) initWithDb:(struct sqlite3*) dbHandle query:(NSString*) query doAssert:(BOOL)doAssert;
-(id) initWithDb:(struct sqlite3*) dbHandle query:(NSString*) query;
-(void) bind:(NSString*) parameter value:(NSString*) value;
-(void) bind:(NSString*) parameter value:(const void*) value size:(unsigned int) size;

-(BOOL) execute;
-(BOOL) executeWithAssert:(BOOL)doAssert;
-(void) reset;
-(BOOL) hasReachedEnd;
-(void) step;

-(double)doubleValue:(NSString*) columnName;
-(int)intValue:(NSString*) columnName;
-(int64_t) int64Value:(NSString*) columnName;
-(int)boolValue:(NSString*) columnName; 
-(NSString*) stringValue:(NSString*) columnName;
-(NSData*) dataValue:(NSString*)columnName;


@property (nonatomic, readonly) int lastStepResult;
@end

