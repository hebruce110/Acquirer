//
//  ChatCommunication.m
//  Acquirer
//
//  Created by peer on 11/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatCommService.h"
#import "JSON.h"
#import "Helper.h"
#import "Acquirer.h"
#import "NSNotificationCenter+CP.h"
#import "ChatMessage.h"
#import "ChatViewController.h"

#define WEBSOCKET_URL @"ws://192.168.29.21:8088/chat/wsChat/aa-bb-cc2"

@implementation ChatCommService

@synthesize delegateCTRL;
@synthesize webSocket;
@synthesize currentCM;

-(void)dealloc{
    self.webSocket = nil;
    [currentCM release];
    [messageQueue release];
    
    [questionIdJoinSTR release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        messageQueue = [[NSMutableArray alloc] init];
        questionIdJoinSTR = [[NSMutableString alloc] init];
    }
    return self;
}

-(void)setUpWebSocket{
    if (self.webSocket == nil) {
        NSURL *url = [NSURL URLWithString:WEBSOCKET_URL];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        
        self.webSocket = [[[SRWebSocket alloc] initWithURLRequest:req] autorelease];
        self.webSocket.delegate = self;
    }
}

-(void)establishConnection{
    if (!self.webSocket) {
        [self setUpWebSocket];
    }
    
    [webSocket open];
}

-(void)joinQuestionId:(ChatMessage *)cm{
    //如果输入＃返回上级菜单
    if ([cm.messageSTR isEqualToString:@"#"]) {
        
        NSRange range = [questionIdJoinSTR rangeOfString:@"," options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            [questionIdJoinSTR setString:[questionIdJoinSTR substringToIndex:range.location]];
        }else{
            [questionIdJoinSTR setString:@"0"];
        }
        
        return;
    }
    
    if (![Helper stringNullOrEmpty:questionIdJoinSTR]) {
        [questionIdJoinSTR appendFormat:@",%@", cm.messageSTR];
    }else{
        [questionIdJoinSTR appendString:cm.messageSTR];
    }
}

-(void)sendMessage:(ChatMessage *)cm{
    self.currentCM = cm;
    
    if (self.webSocket.readyState == SR_OPEN) {
        [self joinQuestionId:cm];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setObject:questionIdJoinSTR forKey:@"question"];
        
        [webSocket send:[dict JSONRepresentation]];
        
        
        NSLog(@"%@", dict);
    }
    else{
        //将建立连接前发送的消息保存到消息队列中
        //当连接建立，只发送最后一条消息
        [self establishConnection];
        [messageQueue addObject:cm];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"WebSocket did open");
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    if (messageQueue.count > 0) {
        [self sendMessage:[messageQueue lastObject]];
        [messageQueue removeAllObjects];
    }
}

-(void)refreshMsgState:(MessageSentState)state{
    currentCM.sentState = state;
    [delegateCTRL refreshMsgState:currentCM];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"Received \"%@\"", [Helper replaceUnicode:message]);
    
    NSDictionary *msgDict = [message JSONValue];
    [delegateCTRL replyFromCS:msgDict];
    
    [self refreshMsgState:MessageSentStateSucceed];
    
    //回顶层菜单，设置菜单为空
    if (NotNilAndEqualsTo(msgDict, @"question", @"0")) {
        [questionIdJoinSTR setString:@""];
    }else{
        [questionIdJoinSTR setString:[msgDict objectForKey:@"question"]];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    //Operation timed out
    if ([error code] == 60) {
        [self refreshMsgState:MessageSentStateFailure];
        return;
    }
    
    
    //51 Network is unreachable
    //53 Software caused connection abort
    //54 Connection reset by peer
    //57 Socket is not connected
    //61 Connection refused
    if (error.code==57 || error.code==51 ||
        error.code==61 || error.code==54 ||
        error.code==53 || error.code==60) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"网络连接失败" notifyType:NOTIFICATION_TYPE_WARNING];
    }
    
    
    [self closeConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"WebSocket closed");
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    [self closeConnection];
}

-(void)closeConnection{
    if (!self.webSocket) {
        return;
    }
    
    if (webSocket.readyState != SR_CLOSED) {
        [self.webSocket close];
    }
    
    self.webSocket.delegate = nil;
    self.webSocket = nil;
}


@end
