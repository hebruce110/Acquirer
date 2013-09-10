//
//  TitleTextTableView.m
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TitleTextTableView.h"
#import "TitleTextTableCell.h"

@implementation TitleTextTableView

-(void)dealloc{
    [TTDelegate release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        TTDelegate = [[TitleTextDelegate alloc] init];
        self.delegate = TTDelegate;
    }
    return self;
}

@end


@implementation TitleTextDelegate

@synthesize rowHeight, contentList;

-(void)dealloc{
    [contentList release];
    
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
    return [contentList count];
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
    return rowHeight;
}

@end