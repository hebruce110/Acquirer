//
//  FormTableView.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormTableDelegate;
@class BaseViewController;

@interface FormTableView : UITableView{
    FormTableDelegate *delegateFT;
}

-(void)setFormTableDataSource:(NSMutableArray *)formList;

-(void)setDelegateViewController:(BaseViewController *)baseCTRL;

@end
