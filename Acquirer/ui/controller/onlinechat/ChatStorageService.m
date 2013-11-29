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
#import "Acquirer.h"

static ChatStorageService *sInstance = nil;

@implementation ChatStorageService

@synthesize lastStepResult, tableNameSTR;

-(void)dealloc{
    [ChatStorageService tearDownChatStorageDateBase];
    [tableNameSTR release];
    
    [super dealloc];
}

+(void)setUpChatStorageDataBase{
    NSString *dbNameSTR = @"chatmessage.db";
    
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

+(void)tearDownChatStorageDateBase{
    sqlite3_close([self sharedInstance]->chatMessageDBHandle);
}

+ (NSString *)chatMsgTableName{
    Acquirer *ac = [Acquirer sharedInstance];
    NSString *chatMsgTableSTR = [NSString stringWithFormat:@"chat_msg_%@_%@", ac.currentUser.instSTR, ac.currentUser.opratorSTR];
    return chatMsgTableSTR;
}

+ (void)initialize{
    [self setUpChatStorageDataBase];
}

//统一日期存取格式
+(NSDateFormatter *)chatMsgGeneralDBDateFormatter{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

-(void)doChatMsgCreateTable{
    NSString *createCMTableSQLFormat = @"CREATE TABLE IF NOT EXISTS %@("
                                        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                        "msg TEXT DEFAULT NULL,"
                                        "msg_tag TEXT,"
                                        "sent_by TEXT,"
                                        "sent_state  TEXT,"
                                        "date TEXT );";
    
    NSString *createCMTableSQL = [NSString stringWithFormat:createCMTableSQLFormat, [self.class chatMsgTableName]];
    
    [[CPSqlQuery queryWithDb:chatMessageDBHandle query:createCMTableSQL] execute];
}

-(void)doChatMsgBatchSaveExecution:(NSMutableArray *)messages{
    NSDateFormatter *formatter = [self.class chatMsgGeneralDBDateFormatter];
    
    NSString *insertCMSQLFormat = @"INSERT INTO %@ (msg, msg_tag, sent_by, sent_state, date) "
                            "values (:msg, :msg_tag, :sent_by, :sent_state, :date);";
    NSString *insertCMSQL = [NSString stringWithFormat:insertCMSQLFormat, [self.class chatMsgTableName]];
    CPSqlQuery *cmSaveQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:insertCMSQL];
    
    sqlite3_exec(chatMessageDBHandle, "BEGIN TRANSACTION", nil, nil, nil);
    
    for (ChatMessage *cm in messages) {
        if (cm.msgTag==MessageTagIM && cm.saved==NO) {
            NSString *dateSTR = [formatter stringFromDate:cm.date];
            
            [cmSaveQuery bind:@"msg" value:cm.messageSTR];
            [cmSaveQuery bind:@"msg_tag" value:[NSString stringWithFormat:@"%d", cm.msgTag]];
            [cmSaveQuery bind:@"sent_by" value:[NSString stringWithFormat:@"%d", cm.sentBy]];
            [cmSaveQuery bind:@"sent_state" value:[NSString stringWithFormat:@"%d", cm.sentState]];
            [cmSaveQuery bind:@"date" value:dateSTR];
            
            [cmSaveQuery execute];
            
            if (cmSaveQuery.lastStepResult == SQLITE_OK) {
                NSInteger lastRowID = sqlite3_last_insert_rowid(chatMessageDBHandle);
                NSLog(@"last Row ID %d", lastRowID);
                cm.msgIdSTR = [NSString stringWithFormat:@"%d", lastRowID];
            }else{
                NSLog(@"save Query state error");
            }
            
            cm.saved = YES;
        }
    }
    
    sqlite3_exec(chatMessageDBHandle, "COMMIT TRANSACTION", nil, nil, nil);
}

//加载历史数据
-(void)doChatMsgQueryExecution:(NSMutableArray *)messages firstQuery:(BOOL)isFirst{
    int queryLimit = isFirst ? 3 : 100;
    
    //取最新的数据
    for (ChatMessage *cm in messages) {
        
    }
    
    int count = 0;
    NSString *countAllSQLFormat = @"SELECT count(*) as 'count' FROM %@";
    NSString *countAllSQL = [NSString stringWithFormat:countAllSQLFormat, [self.class chatMsgTableName]];
    
    CPSqlQuery *cpCountQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:countAllSQL];
    [cpCountQuery execute];
    if (cpCountQuery.lastStepResult == SQLITE_ROW) {
        count = [cpCountQuery intValue:@"count"];
        NSLog(@"count in table:%d", count);
    }
    
    NSDateFormatter *formatter = [self.class chatMsgGeneralDBDateFormatter];
    
    
    
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

@end
