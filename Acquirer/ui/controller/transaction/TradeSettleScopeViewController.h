//
//  TradeSettleScopeViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"
#import "ActionSheetPicker.h"

@class GeneralTableView;

@interface TradeSettleScopeViewController : BaseViewController{
    GeneralTableView *dateScopeTV;
    NSIndexPath *curIndexPath;
    
    ActionSheetDatePicker *sheetPicker;
    
    NSMutableArray *dsList;
}

@property (nonatomic, retain) GeneralTableView *dateScopeTV;
@property (nonatomic, retain) ActionSheetDatePicker *sheetPicker;
@property (nonatomic, copy) NSIndexPath *curIndexPath;

@end
