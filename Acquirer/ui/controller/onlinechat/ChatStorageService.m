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
#import "Helper.h"
#import "ChatViewController.h"

static ChatStorageService *sInstance = nil;

@implementation ChatStorageService

@synthesize cvCTRL;

-(void)dealloc{
    [ChatStorageService tearDownChatStorageDateBase];
    
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
    
    CPSqlQuery *createQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:createCMTableSQL];
    [createQuery execute];
}

-(void)doChatMsgBatchSaveExecution:(NSMutableArray *)messages{
    NSDateFormatter *formatter = [self.class chatMsgGeneralDBDateFormatter];
    
    NSString *insertCMSQLFormat = @"INSERT INTO %@ (msg, msg_tag, sent_by, sent_state, date) "
                            "values (:msg, :msg_tag, :sent_by, :sent_state, :date);";
    NSString *insertCMSQL = [NSString stringWithFormat:insertCMSQLFormat, [self.class chatMsgTableName]];
    CPSqlQuery *cmSaveQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:insertCMSQL];
    
    sqlite3_exec(chatMessageDBHandle, "BEGIN TRANSACTION", nil, nil, nil);
    
    for (ChatMessage *cm in messages) {
        if (cm.saved==NO) {
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

//取第一条有msgId的ChatMessage
-(NSString *)msgIdForFirstRecord:(NSMutableArray *)messages{
    NSString *msgId = nil;

    for (ChatMessage *cm in messages) {
        if (![Helper stringNullOrEmpty:cm.msgIdSTR]) {
            msgId = [[cm.msgIdSTR copy] autorelease];
            break;
        }
    }
    
    if ([Helper stringNullOrEmpty:msgId]) {
        NSLog(@"No msgId found in messages, encounter error");
    }
    
    return msgId;
}

//获取总记录数
-(int)countAllRecordChatMsg:(NSMutableArray *)messages firstQuery:(BOOL)isFirst{
    int recordCount = 0;
    
    NSString *countAllSQL = nil;
    //第一次进入获取总条数
    //根据总条数做OFFSET计算
    if (isFirst == TRUE) {
        NSString *countAllSQLFormat = @"SELECT count(*) as 'count' FROM %@";
        countAllSQL = [NSString stringWithFormat:countAllSQLFormat, [self.class chatMsgTableName]];
    }
    //不是第一次刷新获取100条数据
    //检查是否有新数据
    else{
        NSString *msgIdSTR = [self msgIdForFirstRecord:messages];
        
        if ([Helper stringNullOrEmpty:msgIdSTR]) {
            return recordCount;
        }
        
        NSString *countAllSQLFormat = @"SELECT count(*) as 'count' FROM %@ WHERE id<%@";
        countAllSQL = [NSString stringWithFormat:countAllSQLFormat, [self.class chatMsgTableName], msgIdSTR];
    }
    
    CPSqlQuery *chatMsgCountQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:countAllSQL];
    [chatMsgCountQuery execute];
    
    if (chatMsgCountQuery.lastStepResult == SQLITE_ROW) {
        recordCount = [chatMsgCountQuery intValue:@"count"];
        NSLog(@"count in table:%d", recordCount);
    }
    [chatMsgCountQuery reset];
    
    return recordCount;
}


//加载历史数据
-(void)doChatMsgQueryExecution:(NSMutableArray *)messages firstQuery:(BOOL)isFirst{
    
    //检查是否有记录
    int totalRecordCount = [self countAllRecordChatMsg:messages firstQuery:isFirst];
    
    //无历史记录
    if (totalRecordCount <= 0) {
        //通知下拉刷新无记录
        [cvCTRL doneLoadingDBChatMsgData:@""];
        
        return;
    }
    
    int queryLimit = isFirst ? 3 : 100;
    NSString *selectSQL = nil;
    
    //第一次刷新取最后3条数据
    if (isFirst == TRUE) {
        NSString *selectSQLFormat = @"SELECT * FROM %@ ORDER BY id DESC LIMIT %d";
        selectSQL = [NSString stringWithFormat:selectSQLFormat, [self.class chatMsgTableName], queryLimit];
    }
    //刷新前100条数据
    else{
        NSString *msgId = [self msgIdForFirstRecord:messages];
        
        //msgId一定不为空，第一次会加载3条数据，如果没有数据，程序出错
        if ([Helper stringNullOrEmpty:msgId]) {
            return;
        }
        
        NSString *selectSQLFormat = @"SELECT * FROM %@ WHERE id<%@ ORDER BY id DESC LIMIT %d";
        selectSQL = [NSString stringWithFormat:selectSQLFormat, [self.class chatMsgTableName], msgId, queryLimit];
    }
    
    //do insertion messages operation
    //从头插入到messages
 
    NSDateFormatter *formatter = [self.class chatMsgGeneralDBDateFormatter];
 
    CPSqlQuery *chatMsgQuery = [CPSqlQuery queryWithDb:chatMessageDBHandle query:selectSQL];
    
    [chatMsgQuery execute];
    
    while (chatMsgQuery.lastStepResult == SQLITE_ROW) {
        ChatMessage *cm = [[[ChatMessage alloc] init] autorelease];
        cm.msgIdSTR = [NSString stringWithFormat:@"%d", [chatMsgQuery intValue:@"id"]];
        cm.messageSTR = [chatMsgQuery stringValue:@"msg"];
        cm.msgTag = [[chatMsgQuery stringValue:@"msg_tag"] intValue];
        cm.sentBy = [[chatMsgQuery stringValue:@"sent_by"] intValue];
        cm.sentState = [[chatMsgQuery stringValue:@"sent_state"] intValue];
        //去除发送等待状态
        if (cm.sentState == MessageSentStatePending) {
            cm.sentState = MessageSentStateFailure;
        }
        cm.date = [formatter dateFromString:[chatMsgQuery stringValue:@"date"]];
        cm.saved = YES;
        
        NSLog(@"%@", cm);
        
        //从头插入消息
        [messages insertObject:cm atIndex:0];
        
        [chatMsgQuery execute];
    }
    
    if (isFirst == NO) {
        [cvCTRL performSelectorOnMainThread:@selector(doneLoadingDBChatMsgData:) withObject:@"" waitUntilDone:NO];
    }
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
