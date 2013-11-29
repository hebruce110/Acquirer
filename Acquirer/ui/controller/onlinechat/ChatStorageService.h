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

-(void)doChatMsgCreateTable;
-(void)doChatMsgBatchSaveExecution:(NSMutableArray *)messages;

//加载历史数据
-(void)doChatMsgQueryExecution:(NSMutableArray *)messages firstQuery:(BOOL)isFirst;

@end
