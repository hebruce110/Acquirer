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
#import "PlainUnitTableCell.h"
#import "PlainCellUpDownCell.h"
#import "BaseViewController.h"
#import "LineBreakTableCell.h"
#import "UILabel+Size.h"

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
    static NSString *unit_identifier = @"Unit_Identifier";
    static NSString *updown_identifier = @"UpDown_Identifier";
    static NSString *form_identifier = @"Form_Identifier";
    static NSString *titlelinebreak_indentifier = @"titlelinebreak_indentifier";
    
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
        
        [plaincell.textLabel setContentMode:UIViewContentModeCenter];
        
        if (content.bgColor != nil) {
            plaincell.backgroundColor = content.bgColor;
        }
        
        cell = plaincell;
    }
    
    else if (cc.cellStyle == Cell_Style_Title_LineBreak){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        LineBreakTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:titlelinebreak_indentifier];
        if (plaincell==nil) {
            plaincell = [[[LineBreakTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titlelinebreak_indentifier] autorelease];
        }
        
        
        if (content.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            CGFloat titleWidth = plaincell.bounds.size.width-60;
            CGFloat height = [UILabel calcLabelSizeWithString:content.titleSTR
                                                      andFont:plaincell.titleLabel.font
                                                     maxLines:100
                                                    lineWidth:titleWidth].height;
            plaincell.titleLabel.frame = CGRectMake(plaincell.titleLabel.frame.origin.x,
                                                    plaincell.titleLabel.frame.origin.y,
                                                    titleWidth,
                                                    height);
        }else{
            CGFloat height = [UILabel calcLabelSizeWithString:content.titleSTR
                                                      andFont:plaincell.titleLabel.font
                                                     maxLines:100
                                                    lineWidth:plaincell.titleLabel.frame.size.width].height;
            plaincell.titleLabel.frame = CGRectMake(plaincell.titleLabel.frame.origin.x,
                                                    plaincell.titleLabel.frame.origin.y,
                                                    plaincell.titleLabel.frame.size.width,
                                                    height);
        }
        
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        plaincell.titleLabel.text = content.titleSTR;
        
        plaincell.titleLabel.numberOfLines = [UILabel calcLabelLineWithString:content.titleSTR andFont:plaincell.titleLabel.font lineWidth:plaincell.titleLabel.bounds.size.width];
        
        plaincell.accessoryType = content.accessoryType;
        
        cell = plaincell;
    }
    
    else if (cc.cellStyle == Cell_Style_Standard){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        UITableViewCell *plaincell = [tableView dequeueReusableCellWithIdentifier:standard_identifier];
        if (plaincell==nil) {
            plaincell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:standard_identifier] autorelease];
        }
        
        plaincell.textLabel.text = content.titleSTR;
        plaincell.textLabel.textAlignment = content.alignment;
        plaincell.imageView.image = [UIImage imageNamed:content.imgNameSTR];
        
        plaincell.accessoryType = content.accessoryType;
        
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
    else if (cc.cellStyle == Cell_Style_Unit){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        PlainUnitTableCell *plaincell = [tableView dequeueReusableCellWithIdentifier:unit_identifier];
        if (plaincell == nil) {
            plaincell = [[[PlainUnitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:linebreak_identifier] autorelease];
        }
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
        plaincell.selectionStyle = UITableViewCellSelectionStyleGray;
        plaincell.accessoryType = content.accessoryType;
        
        cell = plaincell;
    }
    else if (cc.cellStyle == Cell_Style_UpDown){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        PlainCellUpDownCell *plaincell = [tableView dequeueReusableCellWithIdentifier:updown_identifier];
        if (plaincell == nil) {
            plaincell = [[[PlainCellUpDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:updown_identifier] autorelease];
        }
        
        plaincell.titleLabel.text = content.titleSTR;
        plaincell.textLabel.text = content.textSTR;
        
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
    else if (cc.cellStyle == Cell_Style_UpDown){
        return DEFAULT_ROW_HEIGHT*4/3;
    }
    else if (cc.cellStyle == Cell_Style_Title_LineBreak){
        PlainCellContent *content = (PlainCellContent *)cc;
        
        LineBreakTableCell *cell = [[[LineBreakTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease];
        
        CGFloat lines;
        if (content.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            lines = [UILabel calcLabelLineWithString:content.titleSTR
                                               andFont:cell.titleLabel.font
                                             lineWidth:cell.titleLabel.bounds.size.width-30];
        }else{
            lines = [UILabel calcLabelLineWithString:content.titleSTR
                                             andFont:cell.titleLabel.font
                                           lineWidth:cell.titleLabel.bounds.size.width];
        }
        
        if (lines >= 1) {
            return DEFAULT_ROW_HEIGHT+(lines-1)*[content.titleSTR sizeWithFont:cell.titleLabel.font].height;
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
