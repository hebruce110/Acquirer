//
//  ChatStorageService.h
//  Acquirer
//
//  Created by peer on 11/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ChatStorageService : NSObject{
    struct sqlite3* chatMessageDBHandle;
    NSString *tableNameSTR;
    
    int lastStepResult;
}

@property (nonatomic, assign) int lastStepResult;
@property (nonatomic, copy) NSString *tableNameSTR;

+(NSDateFormatter *)chatMsgGeneralDBDateFormatter;
+(ChatStorageService *)sharedInstance;
+(void)destroySharedInstance;

@end
