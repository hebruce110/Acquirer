//
//  UserInfomationViewController.m
//  Acquirer
//
//  Created by peer on 11/5/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "UserInfomationViewController.h"
#import "GeneralTableView.h"
#import "Acquirer.h"
#import "PlainCellContent.h"

@implementation UserInfomationViewController

@synthesize userInfoTV;

-(void)dealloc{
    [userInfoTV release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"个人信息"];
    
    NSArray *templeList = @[@[@"机构号：", [Acquirer sharedInstance].currentUser.instSTR],
                            @[@"操作员号：", [Acquirer sharedInstance].currentUser.opratorSTR]];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    for (NSArray *List in templeList) {
        PlainCellContent *pc = [[PlainCellContent new] autorelease];
        pc.titleSTR = [List objectAtIndex:0];
        pc.textSTR = [List objectAtIndex:1];
        pc.cellStyle = Cell_Style_Plain;
        [secOne addObject:pc];
    }
    
    self.userInfoTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, self.contentView.bounds.size.width, self.contentView.bounds.size.height)
                                                        style:UITableViewStyleGrouped] autorelease];
    [userInfoTV setGeneralTableDataSource:[NSMutableArray arrayWithObject:secOne]];
    [self.contentView addSubview:userInfoTV];
}


@end
