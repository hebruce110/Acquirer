//
//  ChatMessageService.m
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel

@synthesize messages;

-(void)dealloc{
    [messages release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        messages = [[NSMutableArray alloc] init];
    }
    return self;
}

//加载历史聊天记录
-(void)loadMessages{
    [messages removeAllObjects];
    
    
}

//保存聊天记录
-(void)saveMessages{
    
}

//添加聊天记录
-(int)addMessage:(ChatMessage *)chatMsg{
    [self.messages addObject:chatMsg];
    [self saveMessages];
    
    return self.messages.count-1;
}

@end
