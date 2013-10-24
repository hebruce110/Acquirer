//
//  FormTableDelegate.m
//  Acquirer
//
//  Created by ben on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "FormTableDelegate.h"
#import "FormCellPattern.h"
#import "FormTableCell.h"

@implementation FormTableDelegate

@synthesize CTRL;
@synthesize rowHeight, formList;

//setup cell class
-(void)setFormList:(NSMutableArray *)list{
    if (formList != list) {
        [list retain];
        [formList release];
        formList = list;
        
        FormCellPattern *pattern = [list objectAtIndex:0];
        cellClass = pattern.formCellClass;
    }
}

-(void)dealloc{
    [formList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        rowHeight = DEFAULT_ROW_HEIGHT;
    }
    return self;
}

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [formList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Form_Identifier";
    
    FormTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.CTRLdelegate = CTRL;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setFormCellPattern:[formList objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

@end
