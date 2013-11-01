//
//  HelpHomeViewController.h
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

@class GeneralTableView;

@interface HelpHomeViewController : BaseViewController{
    GeneralTableView *helpTV;
    NSMutableArray *helpList;
}

@property (nonatomic, retain) GeneralTableView *helpTV;

@end
