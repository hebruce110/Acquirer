//
//  FormTableView.h
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormTableDelegate;

@interface FormTableView : UITableView{
    FormTableDelegate *delegateFT;
}

-(void)setDelegateFormList:(NSMutableArray *)formList;

@end
