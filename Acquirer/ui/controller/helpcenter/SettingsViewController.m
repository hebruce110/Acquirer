//
//  SettingsViewController.m
//  Acquirer
//
//  Created by peer on 11/5/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "SettingsViewController.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"
#import "UserInfomationViewController.h"
#import "AboutAcquirerAppViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *resArray;

@property (retain, nonatomic) UISwitch *swh;

@end

@implementation SettingsViewController

-(void)dealloc{
    [_settingsTV release];
    self.swh = nil;
    self.resArray = nil;
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        _resArray = [[NSMutableArray alloc] init];
        _settingsTV = nil;
        _swh = nil;
    }
    return self;
}

-(void)setUpSettingList{
    [_resArray removeAllObjects];
    
    NSArray *titleArray = @[@"个人信息", @"关于软件", @"检查更新", @"接收消息推送"];
    NSArray *imgArray = @[@"logininfo", @"about", @"update", @"guestbook"];
    
    NSMutableArray *arr0 = [NSMutableArray arrayWithCapacity:0];
    for(NSInteger ix = 0; ix < titleArray.count; ix ++)
    {
        NSString *title = [titleArray objectAtIndex:ix];
        NSString *img = [imgArray objectAtIndex:ix];
        
        NSDictionary *dict = @{@"title":title, @"img":img};
        [arr0 addObject:dict];
    }
    
    NSArray *arr1 = @[@{@"title":@"退出登录", @"img":@""}];
    [_resArray addObject:arr0];
    [_resArray addObject:arr1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"设置"];
    
    [self setUpSettingList];
    
    _swh = [[UISwitch alloc] init];
    _swh.on = [MessageNumberData receiveNotification];
    
    [_swh addTarget:self action:@selector(swhValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    
    _settingsTV = [[GeneralTableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
    _settingsTV.dataSource = self;
    _settingsTV.delegate = self;
    [_settingsTV setRowHeight:DEFAULT_ROW_HEIGHT];
    _settingsTV.contentInset = UIEdgeInsetsMake(GENERALTABLE_OFFSET, 0, 0, 0);
    [self.contentView addSubview:_settingsTV];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate manuallyLogout];
    }
}

- (void)checkUpdate
{
    //检查版本更新
    [[AcquirerService sharedInstance].postbeService requestForInAppVersionCheck];
}

- (void)swhValueDidChanged:(UISwitch *)sw
{
    [MessageNumberData setReceiveNotification:sw.on];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_resArray.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[_resArray objectAtIndex:section] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
    
    NSDictionary *dict = [[_resArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"title"];
    NSString *img = [dict objectForKey:@"img"];
    
    cell.imageView.image = [UIImage imageNamed:img];
    cell.textLabel.text = title;
    
    if(indexPath.section == 1)
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if(indexPath.section == 0 && indexPath.row < 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _swh.center = CGPointMake(290.0f - _swh.bounds.size.width / 2.0f, DEFAULT_ROW_HEIGHT / 2.0f);
        [cell.contentView addSubview:_swh];
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return (cell);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserInfomationViewController *usrInfoCTRL = [[[UserInfomationViewController alloc] init] autorelease];
            [self.navigationController pushViewController:usrInfoCTRL animated:YES];
        }else if (indexPath.row == 1){
            AboutAcquirerAppViewController *aboutCTRL = [[[AboutAcquirerAppViewController alloc] init] autorelease];
            [self.navigationController pushViewController:aboutCTRL animated:YES];
        }else if (indexPath.row == 2){
            [self checkUpdate];
        }
    }
    //退出登录
    else if (indexPath.section==1 && indexPath.row==0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"是否退出汇付POS客户端？" delegate:self
                                                  cancelButtonTitle:@"返回"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
}

@end
