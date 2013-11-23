//
//  MessageCenterViewController.m
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "NoticeViewController.h"

@interface MessageCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *msgList;

@end

@implementation MessageCenterViewController

- (void)dealloc
{
    [_tableView release];
    _tableView = nil;
    
    [_msgList release];
    _msgList = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)init
{
    self = [super init];
    if (self) {
        _msgList = nil;
        _tableView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"消息中心"];
    
    _msgList = [[NSMutableArray alloc] initWithCapacity:0];
    [self makeMsgList];
    
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setRowHeight:DEFAULT_ROW_HEIGHT];
    [self.contentView addSubview:_tableView];
}

- (void)makeMsgList
{
    if(_msgList)
    {
        [_msgList removeAllObjects];
        
        NSArray *imgArray = [NSArray arrayWithObjects:@"", @"", @"", nil];
        NSArray *textArray = [NSArray arrayWithObjects:@"公告", @"通知", @"留言箱", nil];
        NSArray *msgTypeArray = [NSArray arrayWithObjects:@(messageNotice), @(messageNotificatin), @(messageLeaveMsg), nil];
        for(NSInteger index = 0; index < imgArray.count; index ++)
        {
            NSString *img = [imgArray objectAtIndex:index];
            NSString *text = [textArray objectAtIndex:index];
            id type = [msgTypeArray objectAtIndex:index];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:img, @"image", text, @"text", type, @"type", nil];
            [_msgList addObject:dict];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCenterCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSDictionary *dict = [_msgList objectAtIndex:indexPath.row];
    NSString *imgName = [dict objectForKey:@"image"];
    NSString *text = [dict objectForKey:@"text"];
    
    UIImage *image = [UIImage imageNamed:imgName];
    
    cell.imageView.image = image;
    cell.textLabel.text = text;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return (cell);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [_msgList objectAtIndex:indexPath.row];
    MessageFlag type = (MessageFlag)[[dict objectForKey:@"type"] unsignedIntegerValue];
    
    NoticeViewController *noticeViewCtrl = [[NoticeViewController alloc] init];
    noticeViewCtrl.msgFlag = type;
    [self.navigationController pushViewController:noticeViewCtrl animated:YES];
    [noticeViewCtrl release];
}

@end

