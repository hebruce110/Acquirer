//
//  ChatMessage.m
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

@synthesize messageSTR, date;

@synthesize sentBy, sentState, msgTag;
@synthesize bubbleSize;

-(void)dealloc{
    [messageSTR release];
    [date release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        sentState = MessageSentStatePending;
        msgTag = MessageTagIM;
        
        static int i=0;
        if (i%2 == 0) {
            sentBy = MessageSentByUser;
        }else{
            sentBy = MessageSentByCS;
        }
        i++;
    }
    return self;
}


@end