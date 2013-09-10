//
//  FormTableView.m
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "FormTableView.h"
#import "FormTableDelegate.h"

@implementation FormTableView

-(void)dealloc{
    [delegateFT release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        delegateFT = [[FormTableDelegate alloc] init];
        self.delegate = delegateFT;
        self.dataSource = delegateFT;
    }
    return self;
}

-(void)setDelegateFormList:(NSMutableArray *)formList{
    delegateFT.formList = formList;
}

@end
