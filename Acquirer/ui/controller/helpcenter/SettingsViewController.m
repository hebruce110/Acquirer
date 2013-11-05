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

@implementation SettingsViewController

@synthesize settingsTV;

-(void)dealloc{
    [settingsTV release];
    [settingList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        settingList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpSettingList{
    NSArray *conList = @[@[@"个人信息", @"logininfo.png"],
                         @[@"关于软件", @"about.png"]];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSArray *List in conList) {
        PlainCellContent *pc = [[PlainCellContent new] autorelease];
        pc.titleSTR = [List objectAtIndex:0];
        pc.imgNameSTR = [List objectAtIndex:1];
        pc.cellStyle = Cell_Style_Standard;
        pc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [secOne addObject:pc];
    }
    [settingList addObject:secOne];
    
    NSMutableArray *secTwo = [[[NSMutableArray alloc] init] autorelease];
    PlainCellContent *pc = [[PlainCellContent new] autorelease];
    pc.titleSTR = @"退出登录";
    pc.cellStyle = Cell_Style_Standard;
    pc.accessoryType = UITableViewCellAccessoryNone;
    pc.alignment = NSTextAlignmentCenter;
    [secTwo addObject:pc];
    
    [settingList addObject:secTwo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"设置"];
    
    float contentWidth = self.contentView.bounds.size.width;
    float contentHeight = self.contentView.bounds.size.height;
    
    [self setUpSettingList];
    self.settingsTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWidth, contentHeight)
                                                         style:UITableViewStyleGrouped] autorelease];
    [settingsTV setGeneralTableDataSource:settingList];
    [settingsTV setDelegateViewController:self];
    [self.contentView addSubview:settingsTV];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UserInfomationViewController *usrInfoCTRL = [[[UserInfomationViewController alloc] init] autorelease];
            [self.navigationController pushViewController:usrInfoCTRL animated:YES];
        }else if (indexPath.row == 1){
            AboutAcquirerAppViewController *aboutCTRL = [[[AboutAcquirerAppViewController alloc] init] autorelease];
            [self.navigationController pushViewController:aboutCTRL animated:YES];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate manuallyLogout];
    }
}

@end
