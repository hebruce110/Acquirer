//
//  FAQViewController.m
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "FAQViewController.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"
#import "FAQuestionViewController.h"

@implementation FAQViewController

@synthesize faqTV;

-(void)dealloc{
    [faqTV release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setNavigationTitle:@"常见问题"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    NSArray *titleList = @[@"交易类常见问题", @"结算类常见问题"];
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *title in titleList) {
        PlainCellContent *pc = [[PlainCellContent new] autorelease];
        pc.titleSTR = title;
        pc.cellStyle = Cell_Style_Standard;
        pc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [secOne addObject:pc];
    }
    
    
    self.faqTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWidth, contentHeight)
                                                   style:UITableViewStyleGrouped] autorelease];
    [faqTV setDelegateViewController:self];
    [faqTV setGeneralTableDataSource:[NSMutableArray arrayWithObject:secOne]];
    [self.contentView addSubview:faqTV];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FAQuestionViewController *faquestionCTRL = [[[FAQuestionViewController alloc] init] autorelease];
    faquestionCTRL.faqType = indexPath.row;
    [self.navigationController pushViewController:faquestionCTRL animated:YES];
}

@end
