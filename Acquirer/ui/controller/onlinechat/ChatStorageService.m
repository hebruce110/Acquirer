//
//  ChatStorageService.m
//  Acquirer
//
//  Created by peer on 11/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatStorageService.h"
#import "CPSqlQuery.h"
#import "ChatMessage.h"

static ChatStorageService *sInstance = nil;

@implementation ChatStorageService

@synthesize lastStepResult, tableNameSTR;

-(void)dealloc{
    [ChatStorageService tearDownChatStorageDateBase];
    [tableNameSTR release];
    
    [super dealloc];
}

+(void)setUpChatStorageDataBase{
    NSString *dbNameSTR = @"ChatMessage.db";
    
    NSArray* folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dbPath = [[folders objectAtIndex:0] stringByAppendingPathComponent:dbNameSTR];
    
    sqlite3_initialize();
    BOOL openRes = sqlite3_open_v2([dbPath UTF8String], &[self sharedInstance]->chatMessageDBHandle,
                                   SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (openRes != SQLITE_OK) {
        NSLog(@"open SQLite Error!");
        [self sharedInstance]->chatMessageDBHandle = nil;
    }
}

+ (void)initialize{
    [self setUpChatStorageDataBase];
    
    NSString *createCMTableSQL = @"CREATE TABLE IF NOT EXISTS chat_msg("
                                    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                    "msg_tag INTEGER,"
                                    "sent_by INTEGER,"
                                    "sent_state  INTEGER,"
                                    "date TEXT );";
    
    [[CPSqlQuery queryWithDb:[self sharedInstance]->chatMessageDBHandle query:createCMTableSQL] execute];
}

//统一日期存取格式
+(NSDateFormatter *)chatMsgGeneralDBDateFormatter{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

-(void)doChatMsgBatchSaveExecution:(NSMutableArray *)messages{
    NSDateFormatter *formatter = [self.class chatMsgGeneralDBDateFormatter];
    
    NSString *insertCMSQL = @"INSERT INTO chat_msg (msg, msg_tag, sent_by, sent_state, date) values ("Hello World!", 1, 1, 1, "2013-11-28 20:31:11");";
    CPSqlQuery *cmSaveQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:insertValuesSQL];
    
    sqlite3_exec(chatMessageDBHandle, "BEGIN TRANSACTION", nil, nil, nil);
    
    for (ChatMessage *cm in messages) {
        //聊天消息 &&
        if (cm.msgTag==MessageTagIM && cm.saved==NO) {
            NSString *dateSTR = [formatter stringFromDate:cm.date];
            
            
            
            cm.saved = YES;
        }
    }
    
    sqlite3_exec(chatMessageDBHandle, "COMMIT TRANSACTION", nil, nil, nil);
}


+(ChatStorageService *)sharedInstance{
    if (sInstance == nil) {
        sInstance = [[ChatStorageService alloc] init];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

+(void)tearDownChatStorageDateBase{
    BOOL closeRes = sqlite3_close([self sharedInstance]->chatMessageDBHandle);
    if (closeRes == SQLITE_BUSY) {
        
    }
}


@end
