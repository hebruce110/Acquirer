//
//  ChatCommunication.h
//  Acquirer
//
//  Created by peer on 11/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "ChatMessage.h"

@class ChatViewController;

@interface ChatCommService : NSObject <SRWebSocketDelegate>{
    SRWebSocket *webSocket;
    //当前发送的聊天对象
    ChatMessage *currentCM;
    
    //问题列表连接
    NSMutableString *questionIdJoinSTR;
    
    ChatViewController *delegateCTRL;
    
    NSMutableArray *messageQueue;
}

@property (nonatomic, assign) ChatViewController *delegateCTRL;

@property (nonatomic, retain) SRWebSocket *webSocket;
@property (nonatomic, retain) ChatMessage *currentCM;

-(void)establishConnection;

-(void)closeConnection;

-(void)sendMessage:(ChatMessage *)cm;


@end
