//
//  TradeHScopeViewController.h
//  Acquirer
//
//  Created by peer on 10/29/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ActionSheetPicker.h"

@class GeneralTableView;

@interface TradeHScopeViewController : BaseViewController{
    GeneralTableView *historyScopeTV;
    NSIndexPath *curIndexPath;
    
    ActionSheetStringPicker *stringPicker;
    ActionSheetDatePicker *datePicker;
    
    NSMutableArray *devList;
    NSString *devIdSTR;
    
    NSMutableArray *hsList;
}

@property (nonatomic, retain) GeneralTableView *historyScopeTV;
@property (nonatomic, copy) NSIndexPath *curIndexPath;

@property (nonatomic, retain) ActionSheetStringPicker *stringPicker;
@property (nonatomic, retain) ActionSheetDatePicker *datePicker;

@property (nonatomic, copy) NSString *devIdSTR;

@end
