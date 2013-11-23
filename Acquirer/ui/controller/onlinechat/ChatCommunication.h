//
//  ChatCommunication.h
//  Acquirer
//
//  Created by peer on 11/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface ChatCommunication : NSObject <SRWebSocketDelegate>{
    SRWebSocket *webSocket;
}

@property (nonatomic, retain) SRWebSocket *webSocket;

-(void)establishConnection;

-(void)closeConnection;

-(void)sendMessage:(NSString *)msgSTR;


@end
