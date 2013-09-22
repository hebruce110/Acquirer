//
//  PlainTableView.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainTableView.h"

@implementation PlainTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        delegatePT = [[PlainTableDelegate alloc] init];
        self.delegate = delegatePT;
        self.dataSource = delegatePT;
    }
    return self;
}

//set FormTableDelegate formList
-(void)setPlainTableDataSource:(NSMutableArray *)_plainList{
    delegatePT.plainList = _plainList;
}

@end
