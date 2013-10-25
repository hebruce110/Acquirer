//
//  GeneralTableDelegate.m
//  Acquirer
//
//  Created by peer on 10/25/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "GeneralTableDelegate.h"
#import "CellContent.h"
#import "FormCellContent.h"
#import "FormTableCell.h"
#import "PlainCellContent.h"
#import "PlainTableCell.h"
#import "UILabel+Size.h"
#import "PlainLineBreakTableCell.h"
#import "BaseViewController.h"

@implementation GeneralTableDelegate

@synthesize CTRL, genList;

-(void)dealloc{
    [genList release];
    
    [super dealloc];
}

#pragma mark UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [genList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[genList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *plain_identifier = @"Plain_Identifier";
    static NSString *standard_identifier = @"Standard_Identifier";
    static NSString *linebreak_identifier = @"Linebreak_Identifier";
    static NSString *form_identifier = @"Form_Identifier";
    
    CellContent *cc = [[genList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    if (cc.cellStyle == Cell_Style_Plain || cc.cellStyle == Cell_Style_Text_LineBreak) {
        PlainCellContent *content = (PlainCellContent *)cc;
        
        PlainTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:plain_identifier];
        if (plaincell==nil) {
            plaincell = [[[PlainTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:plain_identifier] autorelease];
        }
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
        plaincell.textLabel.numberOfLines = [UILabel calcLabelLineWithString:content.textSTR andFont:plaincell.textLabel.font lineWidth:plaincell.textLabel.bounds.size.width];
        
        if (plaincell.textLabel.numberOfLines > 1) {
            plaincell.textLabel.center = CGPointMake(plaincell.textLabel.center.x, CGRectGetMidY(plaincell.bounds)+10);
        }
        
        [plaincell.textLabel setContentMode:UIViewContentModeCenter];
        
        if (content.bgColor != nil) {
            plaincell.backgroundColor = content.bgColor;
        }
        
        cell = plaincell;
    }
    else if (cc.cellStyle == Cell_Style_Standard){
        PlainCellContent *content = (PlainCellContent *)cc;
        
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
    else if (cc.cellStyle == Cell_Style_LineBreak){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        PlainLineBreakTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:linebreak_identifier];
        if (plaincell == nil) {
            plaincell = [[[PlainLineBreakTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linebreak_identifier] autorelease];
        }
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell = plaincell;
        
    }
    else if (cc.cellStyle == Cell_Style_Form){
        FormCellContent *content = (FormCellContent *)cc;
        
        FormTableCell *formcell = [tableView dequeueReusableCellWithIdentifier:form_identifier];
        if (formcell==nil) {
            formcell = [[[content.formCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:form_identifier] autorelease];
        }
        
        formcell.CTRLdelegate = CTRL;
        formcell.selectionStyle = UITableViewCellSelectionStyleNone;
        [formcell setFormCellPattern:content];
        
        cell = formcell;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellContent *cc = [[genList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cc.cellStyle == Cell_Style_LineBreak){
        return DEFAULT_ROW_HEIGHT*2.0;
    }
    else if (cc.cellStyle == Cell_Style_Text_LineBreak || cc.cellStyle == Cell_Style_Plain){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        CGFloat lines = [UILabel calcLabelLineWithString:content.textSTR andFont:[UIFont boldSystemFontOfSize:16] lineWidth:PLAIN_CELL_TEXT_WIDTH];
        if (lines >= 1) {
            return DEFAULT_ROW_HEIGHT+(lines-1)*[content.textSTR sizeWithFont:[UIFont boldSystemFontOfSize:16]].height;
        }
    }
    return DEFAULT_ROW_HEIGHT;
}

-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (genList.count <= 1) {
        return 0;
    }
    return DEFAULT_TABLE_SECITON_PADDING;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (CTRL && [CTRL respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [CTRL didSelectRowAtIndexPath:indexPath];
    }
}

@end
