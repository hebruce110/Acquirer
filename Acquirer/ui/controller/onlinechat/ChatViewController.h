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
#import "ChatCommunication.h"

@interface ChatViewController : BaseViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>{
    UITableView *chatTV;
    UIImageView *dialogueBgView;
    UITextField *dialogueTextField;
    
    EGORefreshTableHeaderView *refreshHeaderView;
    
    ChatCommunication *cc;
    
    ChatMessageModel *cmModel;
    
    BOOL reloading;
}

@property (nonatomic, retain) UITableView *chatTV;

@property (nonatomic, retain) UIImageView *dialogueBgView;
@property (nonatomic, retain) UITextField *dialogueTextField;

@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

@end
