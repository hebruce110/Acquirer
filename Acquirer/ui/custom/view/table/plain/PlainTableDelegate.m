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
#import "PlainLineBreakTableCell.h"
#import "BaseViewController.h"

@implementation PlainTableDelegate

@synthesize CTRL,plainList;

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
    static NSString *plain_identifier = @"Plain_Identifier";
    static NSString *standard_identifier = @"Standard_Identifier";
    static NSString *linebreak_identifier = @"Linebreak_Identifier";
    
    PlainContent *content = [[plainList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    if (content.cellStyle == Cell_Style_Plain) {
        PlainTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:plain_identifier];
        if (plaincell==nil) {
            plaincell = [[[PlainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:plain_identifier] autorelease];
        }
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
        cell = plaincell;
    }
    else if (content.cellStyle == Cell_Style_Standard){
        UITableViewCell *plaincell = [tableView dequeueReusableCellWithIdentifier:standard_identifier];
        if (plaincell==nil) {
            plaincell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standard_identifier] autorelease];
        }
        
        plaincell.textLabel.text = content.titleSTR;
        plaincell.imageView.image = [UIImage imageNamed:content.imgNameSTR];
        plaincell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell = plaincell;
    }
    else if (content.cellStyle == Cell_Style_LineBreak){
        PlainLineBreakTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:linebreak_identifier];
        if (plaincell == nil) {
            plaincell = [[[PlainLineBreakTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linebreak_identifier] autorelease];
        }
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell = plaincell;
        
    }

    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlainContent *content = [[plainList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (content.cellStyle == Cell_Style_LineBreak){
        return DEFAULT_ROW_HEIGHT*2.5;
    }
    return DEFAULT_ROW_HEIGHT;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return DEFAULT_TABLE_SECITON_PADDING;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (CTRL && [CTRL respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [CTRL didSelectRowAtIndexPath:indexPath];
    }
}

@end
