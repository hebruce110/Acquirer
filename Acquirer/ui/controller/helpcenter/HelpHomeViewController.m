//
//  HelpHomeViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "HelpHomeViewController.h"
#import "PlainCellContent.h"
#import "GeneralTableView.h"
#import "ReturnCodeQueryViewController.h"

@implementation HelpHomeViewController

@synthesize helpTV;

-(void)dealloc{
    [helpTV release];
    [helpList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        helpList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpHelpList{
    NSArray *secOne = @[@[@"POS常见问题", @"faq.png", NSObject.class],
                        @[@"生利宝常见问题", @"helpservice.png", NSObject.class],
                        @[@"刷卡返回码查询", @"returncode.png", ReturnCodeQueryViewController.class]];
    
    NSArray *secTwo = @[@[@"消息中心", @"news.png", NSObject.class]];
    NSArray *secThree = @[@[@"设置", @"setup.png", NSObject.class]];
    
    NSArray *templeList = @[secOne, secTwo, secThree];
    
    for (NSArray *list in templeList) {
        NSMutableArray *secList = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<list.count; i++) {
            PlainCellContent *pc = [[PlainCellContent new] autorelease];
            NSArray *array = [list objectAtIndex:i];
            pc.titleSTR = [array objectAtIndex:0];
            pc.imgNameSTR = [array objectAtIndex:1];
            pc.jumpClass = [array objectAtIndex:2];
            pc.cellStyle = Cell_Style_Standard;
            pc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [secList addObject:pc];
        }
        [helpList addObject:secList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"帮助中心"];
	
    [self setUpHelpList];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.helpTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWidth, contentHeight)
                                                     style:UITableViewStyleGrouped] autorelease];
    [self.helpTV setDelegateViewController:self];
    [self.helpTV setGeneralTableDataSource:helpList];
    helpTV.scrollEnabled = NO;
    [self.contentView addSubview:helpTV];
    
    
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlainCellContent *content = [[helpList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (content.jumpClass && [content.jumpClass isSubclassOfClass:BaseViewController.class]) {
        BaseViewController *jpCTRL = [[[content.jumpClass alloc] init] autorelease];
        [self.navigationController pushViewController:jpCTRL animated:YES];
    }
}


@end
