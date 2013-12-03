//
//  ChatMessageService.m
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatMessageModel.h"
#import "ChatStorageService.h"

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

//添加聊天记录
-(int)addMessage:(ChatMessage *)chatMsg{
    [self.messages addObject:chatMsg];
    
    return self.messages.count-1;
}

@end
