//
//  SettingsViewController.h
//  Acquirer
//
//  Created by peer on 11/5/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface SettingsViewController : BaseViewController <UIAlertViewDelegate>{
    GeneralTableView *settingsTV;
    
    NSMutableArray *settingList;
}

@property (nonatomic, retain) GeneralTableView *settingsTV;

@end
