//
//  CustomerChatViewController.m
//  Acquirer
//
//  Created by peer on 11/18/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatMessage.h"
#import "ChatBubbleView.h"
#import "ChatMessageCell.h"
#import "ChatTimeLabelCell.h"
#import "NSNotificationCenter+CP.h"
#import "JSON.h"
#import "ChatStorageService.h"
#import "MessageNumberData.h"

@implementation ChatViewController

@synthesize chatTV;

@synthesize dialogueBgView,dialogueTextField;

@synthesize refreshHeaderView;

-(void)dealloc{
    [cmModel release];
    [chatTV release];
    
    [cc release];
    
    [dialogueBgView release];
    [dialogueTextField release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        isShowTabBar = NO;
        
        cmModel = [[ChatMessageModel alloc] init];
        
        cc = [[ChatCommService alloc] init];
        cc.delegateCTRL = self;
        
        [ChatStorageService sharedInstance].cvCTRL = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"在线客服"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.dialogueBgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bg.png"]] autorelease];
    dialogueBgView.userInteractionEnabled = YES;
    dialogueBgView.frame = CGRectMake(0, contentHeight-DEFAULT_NAVIGATION_BAR_HEIGHT, contentWidth, DEFAULT_NAVIGATION_BAR_HEIGHT);
    [self.contentView addSubview:dialogueBgView];
    
    UIImage *sendImg = [UIImage imageNamed:@"nav-btn.png"];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundImage:[sendImg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 6, 10, 6)] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(contentWidth-65, 0, 60, 35);
    sendBtn.center = CGPointMake(sendBtn.center.x, CGRectGetMidY(naviBgView.bounds));
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sendBtn addTarget:self action:@selector(questionSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    [dialogueBgView addSubview:sendBtn];
    
    int offset = 10;
    
    CGRect textFrame = CGRectMake(10, 8, contentWidth-sendBtn.bounds.size.width-offset*2, 32);
    self.dialogueTextField = [[[UITextField alloc] initWithFrame:textFrame] autorelease];
    dialogueTextField.keyboardType = UIKeyboardTypePhonePad; //UIKeyboardTypeNumbersAndPunctuation;
    dialogueTextField.borderStyle = UITextBorderStyleRoundedRect;
    dialogueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    dialogueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dialogueTextField.placeholder = @"请输入数字以快速获取答复";
    [dialogueBgView addSubview:dialogueTextField];
    dialogueTextField.center = CGPointMake(dialogueTextField.center.x, CGRectGetMidY(naviBgView.bounds));
    
    CGRect chatFrame = CGRectMake(0, 0, contentWidth, contentHeight-dialogueBgView.bounds.size.height);
    self.chatTV = [[UITableView alloc] initWithFrame:chatFrame style:UITableViewStylePlain];
    self.chatTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTV.backgroundColor = [UIColor clearColor];
    self.chatTV.backgroundView = nil;
    self.chatTV.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    self.chatTV.dataSource = self;
    self.chatTV.delegate = self;
    
    [self.contentView addSubview:chatTV];
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.chatTV.bounds.size.height, self.contentView.frame.size.width, self.chatTV.bounds.size.height)];
    refreshHeaderView.delegate = self;
    [self.chatTV addSubview:refreshHeaderView];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapChatTableView:)] autorelease];
    tapGesture.cancelsTouchesInView = NO;
    [self.chatTV addGestureRecognizer:tapGesture];
    
    [self.contentView bringSubviewToFront:dialogueBgView];
    
    //add time label
    ChatMessage *cm = [[ChatMessage alloc] init];
    cm.msgTag = MessageTagTime;
    cm.date = [NSDate date];
    [cmModel.messages addObject:cm];
}

-(void)tapChatTableView:(UITapGestureRecognizer *)tapGesuture{
    [dialogueTextField resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpChatMsgDBEnvironment];
    [[ChatStorageService sharedInstance] doChatMsgQueryExecution:cmModel.messages firstQuery:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setUpWebSocketEnvironment];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setUpWebSocketEnvironment{
    [[Acquirer sharedInstance] showUIPromptMessage:@"网络连接中请稍后..." animated:YES];
    [cc establishConnection];
    
    ChatMessage *firstMsg = [[[ChatMessage alloc] init] autorelease];
    firstMsg.messageSTR = @"0";
    
    [cc sendMessage:firstMsg];
}

-(void)setUpChatMsgDBEnvironment{
    [[ChatStorageService sharedInstance] doChatMsgCreateTable];
}

-(void)questionSendBtn:(id)sender{
    if ([Helper stringNullOrEmpty:dialogueTextField.text]) {
        return;
    }
    
    NSMutableArray *msgList = [[[NSMutableArray alloc] init] autorelease];
    
    BOOL needTimestamp = NO;
    
    for (int i=cmModel.messages.count-1; i>=0; i--) {
        ChatMessage *cm = [cmModel.messages objectAtIndex:i];
        if (cm.msgTag == MessageTagTime) {
            NSDate *curDate = [NSDate date];
            NSTimeInterval time = [curDate timeIntervalSinceDate:cm.date];
            //5 * 60 seconds
            if (time > 5 * 60) {
                needTimestamp = YES;
            }
            break;
        }
    }
    
    if (needTimestamp) {
        ChatMessage *timeCM = [[[ChatMessage alloc] init] autorelease];
        timeCM.msgTag = MessageTagTime;
        timeCM.date = [NSDate date];
        
        [msgList addObject:timeCM];
    }
    
    
    NSString *inputSTR = [[dialogueTextField.text copy] autorelease];
    dialogueTextField.text = @"";
    
    ChatMessage *msgCM = [[[ChatMessage alloc] init] autorelease];
    msgCM.messageSTR = inputSTR;
    msgCM.date = [NSDate date];
    msgCM.sentBy = MessageSentByUser;
    msgCM.sentState = MessageSentStatePending;
    msgCM.msgTag = MessageTagIM;
    
    [msgList addObject:msgCM];
    [self insertMsgListToChatTV:msgList];
    
    [cc sendMessage:msgCM];
}

-(void)replyFromCS:(NSDictionary *)dict{
    if (NotNil(dict, @"answer")) {
        ChatMessage *cm = [[[ChatMessage alloc] init] autorelease];
        cm.messageSTR = [dict objectForKey:@"answer"];
        cm.date = [NSDate date];
        cm.sentBy = MessageSentByCS;
        cm.msgTag = MessageTagIM;
        
        [self insertMsgToChatTV:cm];
    }
}

-(void)insertMsgToChatTV:(ChatMessage *)cm{
    int index = [cmModel addMessage:cm];
    
    [self.chatTV insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                       withRowAnimation:UITableViewRowAnimationFade];
    [self scrollToNewestMessage];
}


-(void)insertMsgListToChatTV:(NSArray *)msgList{
    NSMutableArray *ipList = [[[NSMutableArray alloc] init] autorelease];
    
    for (ChatMessage *cm in msgList) {
        int index = [cmModel addMessage:cm];
        [ipList addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    [self.chatTV insertRowsAtIndexPaths:ipList withRowAnimation:UITableViewRowAnimationFade];
    [self scrollToNewestMessage];
}

-(void)refreshMsgState:(ChatMessage *)cm{
    int index = [cmModel.messages indexOfObject:cm];
    if (index!=NSNotFound && index>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *cell = [self.chatTV cellForRowAtIndexPath:indexPath];
        [cell setNeedsLayout];
    }
}

//刷新最近几个消息的发送状态
-(void)refreshLatestMsgState:(MessageSentState)state{
    NSMutableArray *ipList = [[[NSMutableArray alloc] init] autorelease];
    for (int i=cmModel.messages.count-1; i>=0; i--) {
        ChatMessage *cm = [cmModel.messages objectAtIndex:i];
        if (cm.sentBy == MessageSentByCS) {
            break;
        }else if (cm.sentBy == MessageSentByUser){
            cm.sentState = state;
            [ipList addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    for (NSIndexPath *ip in ipList) {
        UITableViewCell *cell = [self.chatTV cellForRowAtIndexPath:ip];
        [cell setNeedsLayout];
    }
}

-(void)backToPreviousView:(id)sender{
    [MessageNumberData setMessageCount:cmModel.messages.count report:NO];
    [MessageNumberData setMessageLastUpdateDate:[[cmModel.messages lastObject] date]];
    
    [cc closeConnection];

    //保存聊天数据
    [[ChatStorageService sharedInstance] doChatMsgBatchSaveExecution:cmModel.messages];
    
    [cmModel.messages removeAllObjects];
    self.chatTV.delegate = nil;
    self.chatTV.dataSource = nil;
    
    [super backToPreviousView:sender];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

//下拉刷新接口
- (void)reloadTableViewDataSource{
	reloading = YES;
	
    cmRef = [cmModel.messages objectAtIndex:0];
    
    [self performSelectorInBackground:@selector(performDataLoadingAtBackgroundThread) withObject:nil];
}

-(void)performDataLoadingAtBackgroundThread{
    [[ChatStorageService sharedInstance] doChatMsgQueryExecution:cmModel.messages firstQuery:NO];
}

-(void)doneLoadingDBChatMsgData:(NSString *)noticeSTR{
    //修改下拉刷新loading为提示
    
    
    int index = [cmModel.messages indexOfObject:cmRef];
    
    [self.chatTV reloadData];
    
    [self.chatTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                       atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [self doneLoadingTableViewData];
}

- (void)doneLoadingTableViewData{
	
	//model should call this when its done loading
	reloading = NO;
    
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.chatTV];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [dialogueTextField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cmModel.messages.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessage *cm = (cmModel.messages)[indexPath.row];
    
    if (cm.msgTag == MessageTagIM) {
        cm.bubbleSize = [ChatBubbleView sizeForText:cm.messageSTR];
        return cm.bubbleSize.height+CHAT_CELL_VERTICAL_PADDING;
    }
    else if (cm.msgTag == MessageTagTime){
        return CHAT_TIME_LABEL_HEIGHT + CHAT_CELL_VERTICAL_PADDING*1.5;
    }
    
    return DEFAULT_ROW_HEIGHT;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MsgCellIdentifier = @"ChatMessageCell";
    static NSString *TimeCellIdentifier = @"ChatTimeCell";
    
    ChatMessage *cm = (cmModel.messages)[indexPath.row];
    
    UITableViewCell *cell = nil;
    
    if (cm.msgTag == MessageTagIM) {
        ChatMessageCell *chatCell = (ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:MsgCellIdentifier];
        if (chatCell == nil) {
            chatCell = [[[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MsgCellIdentifier] autorelease];
        }
        
        chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ChatMessage *cm = [cmModel.messages objectAtIndex:indexPath.row];
        [chatCell setMessage:cm];
        
        cell = chatCell;
    }
    else if (cm.msgTag == MessageTagTime){
        ChatTimeLabelCell *timeCell = (ChatTimeLabelCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        if (timeCell == nil) {
            timeCell = [[[ChatTimeLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier] autorelease];
        }
        
        timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [timeCell formatDateTime:cm.date]; 
        
        cell = timeCell;
    }
    
    return cell;
}


- (void)scrollToNewestMessage
{
    if (cmModel.messages.count == 0) {
        return ;
    }
    
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(cmModel.messages.count - 1) inSection:0];
	[self.chatTV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"MoveUpText" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.dialogueBgView.frame = CGRectMake(dialogueBgView.frame.origin.x,
                                           self.contentView.bounds.size.height-keyboardRect.size.height-dialogueBgView.bounds.size.height,
                                           dialogueBgView.frame.size.width,
                                           dialogueBgView.frame.size.height);
    
    self.chatTV.frame = CGRectMake(0, 0, chatTV.frame.size.width,
                                   self.contentView.bounds.size.height-keyboardRect.size.height-dialogueBgView.bounds.size.height);
    
    [UIView commitAnimations];
    
    [self scrollToNewestMessage];
}

-(void)keyboardDidShow:(NSNotification *)notification{
    
}

-(void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"MoveDownText" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.dialogueBgView.frame = CGRectMake(dialogueBgView.frame.origin.x,
                                           self.contentView.bounds.size.height-dialogueBgView.bounds.size.height,
                                           dialogueBgView.frame.size.width,
                                           dialogueBgView.frame.size.height);
    
    [UIView commitAnimations];
    
    self.chatTV.frame = CGRectMake(0, 0, chatTV.frame.size.width,
                                   self.contentView.bounds.size.height-dialogueBgView.bounds.size.height);
}

@end
