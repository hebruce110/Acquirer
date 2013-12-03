//
//  CustomerChatViewController.h
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatMessageModel.h"
#import "EGORefreshTableHeaderView.h"
#import "ChatCommService.h"

@interface ChatViewController : BaseViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>{
    UITableView *chatTV;
    UIImageView *dialogueBgView;
    UITextField *dialogueTextField;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
    ChatCommService *cc;
    
    ChatMessageModel *cmModel;
    
    BOOL reloading;
    ChatMessage *cmRef;
}

@property (nonatomic, retain) UITableView *chatTV;

@property (nonatomic, retain) UIImageView *dialogueBgView;
@property (nonatomic, retain) UITextField *dialogueTextField;

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

//建立WebSocket连接
-(void)setUpWebSocketEnvironment;
//建立ChatMsg数据表
-(void)setUpChatMsgDBEnvironment;

//插入消息
-(void)insertMsgToChatTV:(ChatMessage *)cm;

//插入消息列表
-(void)insertMsgListToChatTV:(NSArray *)msgList;

//收到客服JSON格式的回复消息
-(void)replyFromCS:(NSDictionary *)dict;

//刷新消息的状态
-(void)refreshMsgState:(ChatMessage *)cm;

//刷新最近几个消息的发送状态
-(void)refreshLatestMsgState:(MessageSentState)state;

//完成从数据库的数据加载
-(void)doneLoadingDBChatMsgData:(NSString *)noticeSTR;

@end
