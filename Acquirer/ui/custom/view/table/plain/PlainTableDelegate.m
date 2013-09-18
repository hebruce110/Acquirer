//
//  PlainTableDelegate.m
//  Acquirer
//
//  Created by chinapnr on 13-9-18.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "PlainTableDelegate.h"
#import "PlainTableCell.h"
#import "PlainContent.h"

@implementation PlainTableDelegate

@synthesize plainList;

-(void)dealloc{
    [plainList release];
    [super dealloc];
}

#pragma mark UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [plainList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[plainList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Plain_Identifier";
    
    PlainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[PlainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PlainContent *content = [[plainList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.titleLabel.text = content.textSTR;
    cell.textLabel.text = content.textSTR;
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DEFAULT_ROW_HEIGHT;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return DEFAULT_TABLE_SECITON_PADDING;
}

@end
