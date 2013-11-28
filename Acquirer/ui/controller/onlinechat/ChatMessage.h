//
//  ChatMessage.h
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _MessageSentBy{
    //用户发送消息
    MessageSentByUser,
    //客服发送消息 CS customer service
    MessageSentByCS,
} MessageSentBy;

//消息发送状态
typedef enum _MessageSentState{
    //消息发送失败
    MessageSentStateFailure = 0,
    //消息发送成功
    MessageSentStateSucceed,
    //消息等待发送
    MessageSentStatePending,
    
} MessageSentState;

typedef enum _MessageTag{
    //IM消息
    MessageTagIM = 0,
    //时间标签
    MessageTagTime
} MessageTag;

@interface ChatMessage : NSObject{
    //主键
    NSString *msgIdSTR;
    //是否已保存到数据库
    BOOL saved;
    
    NSString *messageSTR;
    NSDate *date;
    
    MessageSentBy sentBy;
    MessageSentState sentState;
    MessageTag msgTag;
    
    CGSize bubbleSize;
}

@property (nonatomic, copy) NSString *msgIdSTR;
@property (nonatomic, assign) BOOL saved;

@property (nonatomic, copy) NSString *messageSTR;
@property (nonatomic, copy) NSDate *date;

@property (nonatomic, assign) MessageSentBy sentBy;
@property (nonatomic, assign) MessageSentState sentState;
@property (nonatomic, assign) MessageTag msgTag;

@property (nonatomic, assign) CGSize bubbleSize;

@end
