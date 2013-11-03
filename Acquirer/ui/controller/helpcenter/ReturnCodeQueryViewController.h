//
//  ReturnCodeQueryViewController.h
//  Acquirer
//
//  Created by peer on 11/1/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;
@class ActionSheetStringPicker;

@interface ReturnCodeQueryViewController : BaseViewController{
    NSMutableArray *codeList;
    GeneralTableView *codeTV;
    
    UITextView *codeDescTextView;
    
    ActionSheetStringPicker *stringPicker;
}

@property (nonatomic, retain) GeneralTableView *codeTV;
@property (nonatomic, retain) UITextView *codeDescTextView;
@property (nonatomic, retain) ActionSheetStringPicker *stringPicker;

@end
