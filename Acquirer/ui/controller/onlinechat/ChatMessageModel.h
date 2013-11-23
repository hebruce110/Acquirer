//
//  ChatMessageService.h
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"

@interface ChatMessageModel : NSObject{
    NSMutableArray *messages;
}

@property (nonatomic, readonly) NSMutableArray *messages;

//加载历史聊天记录
-(void)loadMessages;

//保存聊天记录
-(void)saveMessages;

//添加聊天记录
-(int)addMessage:(ChatMessage *)chatMsg;

@end
