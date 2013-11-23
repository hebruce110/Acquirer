//
//  ChatMessageCell.h
//  Acquirer
//
//  Created by peer on 11/19/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//
#import "ChatMessage.h"
#import "ChatBubbleView.h"

@interface ChatMessageCell : UITableViewCell{
    ChatMessage *cm;
    
    ChatBubbleView *bubbleView;
    
    //消息发送失败图标
    UIImageView *failImageView;
    //客服聊天头像 cusomer service
    UIImageView *csHeadView;
    
    UIActivityIndicatorView *loadingIndicator;
}

@property (nonatomic, retain) ChatMessage *cm;

- (void)setMessage:(ChatMessage*)message;

@end
