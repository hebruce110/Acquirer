//
//  TitleTextTableView.m
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TitleTextTableView.h"
#import "TitleTextTableCell.h"

#define DEFAULT_ROW_HEIGHT 45

@implementation TitleTextDelegate

#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Login_Identifier";
    
    TitleTextTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[TitleTextTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setContent:[contentList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end

@implementation TitleTextTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        
    }
    return self;
}



@end
