//
//  ActivateViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageService.h"

typedef enum{
    //初始正常状态用户可点击按钮获取短信
    MSG_STATE_NORMAL,
    //发送短信成功后禁用按钮并提示n秒后重新获取激活码
    MSG_STATE_SUCCEED
} MsgButtonState;

@interface ActivateViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    UIScrollView *bgScrollView;
    UITableView *activateTableView;
    UIButton *submitBtn;
    
    UIButton *msgBtn;
    NSTimer *msgTimer;
    MsgButtonState msgState;
    
    NSMutableArray *contentList;
    
    NSString *mobileSTR;
    int downCount;
    
    MessageService *msgService;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;
@property (nonatomic, retain) UITableView *activateTableView;
@property (nonatomic, retain) UIButton *submitBtn;

@property (nonatomic, retain) UIButton *msgBtn;
@property (nonatomic, retain) NSTimer *msgTimer;

@property (nonatomic, copy) NSString *mobileSTR;

//恢复发送短信的状态
-(void)restoreShortMessageState;

@end
