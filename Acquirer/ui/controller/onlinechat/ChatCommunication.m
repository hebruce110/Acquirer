//
//  ChatCommunication.m
//  Acquirer
//
//  Created by peer on 11/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatCommunication.h"
#import "JSON.h"
#import "Helper.h"
#import "Acquirer.h"

#define WEBSOCKET_URL @"ws://192.168.21.247:8088/chat/wsChat/aa-bb-cc2"

@implementation ChatCommunication

@synthesize webSocket;

-(void)dealloc{
    self.webSocket = nil;
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        
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

-(void)sendMessage:(NSString *)msgSTR{
    if (self.webSocket.readyState == SR_OPEN) {
        [webSocket send:msgSTR];
    }
    else{
        [self establishConnection];
        [self sendMessage:msgSTR];
    }
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

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", [Helper replaceUnicode:message]);
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    NSLog(@"Websocket Did Connected");
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setObject:@"question" forKey:@"0"];
    [self sendMessage:[dict JSONRepresentation]];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    [self closeConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    [self closeConnection];
}


@end
