//
//  ActivateViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageService.h"
#import "LoginService.h"

@class GeneralTableView;

typedef enum{
    //初始正常状态用户可点击按钮获取短信
    MSG_STATE_NORMAL,
    //发送短信成功后禁用按钮并提示n秒后重新获取激活码
    MSG_STATE_SUCCEED
} MsgButtonState;

typedef enum{
    //验证身份跳转激活
    ACTIVATE_VALIIDENTITY,
    //登录未激活,第一次确认
    ACTIVATE_FIRST_CONFIRM
}ActivateType;

@interface ActivateViewController : BaseViewController <UIGestureRecognizerDelegate>{
    UIScrollView *bgScrollView;
    UILabel *wrongMobileLabel;
    
    GeneralTableView *activateTableView;
    UIButton *submitBtn;
    
    UIButton *msgBtn;
    NSTimer *msgTimer;
    MsgButtonState msgState;
    
    NSMutableArray *patternList;
    
    int downCount;
    
    ActivateType CTRLType;
    
    NSString *pnrDevIdSTR;
    NSString *mobileSTR;
}

@property (nonatomic, retain) UIScrollView *bgScrollView;

@property (nonatomic, retain) UILabel *wrongMobileLabel;

@property (nonatomic, retain) GeneralTableView *activateTableView;
@property (nonatomic, retain) UIButton *submitBtn;

@property (nonatomic, retain) UIButton *msgBtn;
@property (nonatomic, retain) NSTimer *msgTimer;

@property (nonatomic, assign) ActivateType CTRLType;

@property (nonatomic, copy) NSString *pnrDevIdSTR;
@property (nonatomic, copy) NSString *mobileSTR;

//恢复发送短信的状态
-(void)restoreShortMessageState;

//重新回到登录界面
- (void)backToLoginViewCtrl;

@end
