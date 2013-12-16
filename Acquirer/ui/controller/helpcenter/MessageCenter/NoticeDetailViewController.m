//
//  NoticeDetailViewController.m
//  Acquirer
//
//  Created by Soal on 13-11-1.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "SafeObject.h"

@interface NoticeDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) UILabel *noMsgLabel;

@property (retain, nonatomic) NSMutableDictionary *msgDict;

@end

@implementation NoticeDetailViewController

- (void)dealloc
{
    self.tableView = nil;
    self.noMsgLabel = nil;
    self.msgDict = nil;
    self.idCountStr = nil;
    
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
        _msgFlag = messageUnknow;
        _idCountStr = nil;
        _tableView = nil;
        _noMsgLabel = nil;
        _msgDict = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"汇付公告"];
    
    _msgDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.contentView addSubview:_tableView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NoticeService *noticeService = [AcquirerService sharedInstance].noticeService;
    switch(_msgFlag) {
        case messageNotice: {
            [self setNavigationTitle:@"汇付公告"];
            [noticeService requestNoticeDetailByFlag:_msgFlag noticeId:_idCountStr Target:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageNotificatin: {
            [self setNavigationTitle:@"通知"];
            [noticeService requestNoticeDetailByFlag:_msgFlag noticeId:_idCountStr Target:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageLeaveMsg: {
            [self setNavigationTitle:@"留言"];
            [noticeService requestLeaveMessageDetailByMsgId:_idCountStr Target:self action:@selector(requestDidFinished:)];
        }break;
            
        case messageUnknow:
        default:
            break;
    }
}

- (void)requestDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    
    [_msgDict setDictionary:body];
    
    NSString *title = [_msgDict safeJsonObjForKey:@"title"];
    NSString *content = [_msgDict safeJsonObjForKey:@"content"];
    if(!title && !content) {
        if(!_noMsgLabel) {
            _noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width * 0.3f)];
            _noMsgLabel.backgroundColor = [UIColor clearColor];
            _noMsgLabel.font = [UIFont systemFontOfSize:15];
            _noMsgLabel.textColor = [UIColor lightGrayColor];
            _noMsgLabel.textAlignment = NSTextAlignmentCenter;
            NSString *navTitle = self.naviTitleLabel.text;
            if(navTitle && navTitle.length > 2) {
                [navTitle substringWithRange:NSMakeRange(0, 2)];
            }
            _noMsgLabel.text = [NSString stringWithFormat:@"暂无%@", navTitle];
            [_tableView addSubview:_noMsgLabel];
        }
    } else {
        if(_noMsgLabel) {
            [_noMsgLabel removeFromSuperview];
            [_noMsgLabel release];
            _noMsgLabel = nil;
        }
    }
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = 0;
    NSString *title = [_msgDict safeJsonObjForKey:@"title"];
    NSString *content = [_msgDict safeJsonObjForKey:@"content"];
    if(title) {
        sec ++;
    }
    if(content) {
        sec ++;
    }
    return (sec);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    
    NSInteger section = indexPath.section;
    if(section == 0) {
        NSString *title = [_msgDict safeJsonObjForKey:@"title"];
        NSString *tranTimeString = [_msgDict safeJsonObjForKey:@"releaseDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:tranTimeString];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *tranTime = [formatter stringFromDate:date];
        [formatter release];
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = tranTime;
    } else if(section == 1) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        NSString *content = [_msgDict safeJsonObjForKey:@"content"];
        cell.textLabel.text = content;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return (cell);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat space = 10.0f;
    CGSize size = tableView.bounds.size;
    NSInteger section = indexPath.section;
    NSString *content = [_msgDict safeJsonObjForKey:@"content"];
    CGFloat height = [content sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(size.width - space * 4.0f, 4000.0f) lineBreakMode:NSLineBreakByCharWrapping].height;
    
    if(section == 0) {
        return (64.0f);
    }
    else if(section == 1) {
        return (MAX(DEFAULT_ROW_HEIGHT, height + space * 4.0f));
    }
    return (0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
