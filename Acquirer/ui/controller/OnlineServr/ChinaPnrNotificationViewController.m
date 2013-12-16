//
//  ChinaPnrNotificationViewController.m
//  Acquirer
//
//  Created by chinaPnr on 13-11-8.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//  汇付动态

#import "ChinaPnrNotificationViewController.h"
#import "ChinaPnrNotificationDetailViewController.h"
#import "SafeObject.h"

@implementation ChinaPnrNotificationViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"汇付公告"];
    
    [MessageNumberData setNotificationCount:0 update:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.msgList count] != 0) {
        //载入新的内容
        if (self.isShowMore && indexPath.row == self.msgList.count) {
            [self.showMoreIndicator startAnimating];
            [self freshMessage];
        }
        else
        {
            NSDictionary *dict = [self.msgList safeObjectAtIndex:indexPath.row];
            NSString *idCountStr = [dict stringObjectForKey:@"id"];
            ChinaPnrNotificationDetailViewController *detailViewCtrl = [[ChinaPnrNotificationDetailViewController alloc] init];
            detailViewCtrl.msgFlag = self.msgFlag;
            detailViewCtrl.idCountStr = idCountStr;
            [self.navigationController pushViewController:detailViewCtrl animated:YES];
            [detailViewCtrl release];
        }
    }
}

@end
