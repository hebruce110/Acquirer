//
//  FAQuestionAnswerViewController.m
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "FAQuestionAnswerViewController.h"
#import "PlainCellContent.h"
#import "FAQuestionViewController.h"
#import "GeneralTableView.h"

@implementation FAQuestionAnswerViewController

@synthesize faqModel, faqTV;

-(void)dealloc{
    [faqModel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"常见问题详情"];
    
    CGFloat contentWith = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    PlainCellContent *pc = [[PlainCellContent new] autorelease];
    pc.titleSTR = [NSString stringWithFormat:@"Q:%@ A:%@", faqModel.questionSTR, faqModel.answerSTR];
    pc.accessoryType = UITableViewCellAccessoryNone;
    pc.cellStyle = Cell_Style_Title_LineBreak;
    [secOne addObject:pc];
    
    self.faqTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWith, contentHeight)
                                                   style:UITableViewStyleGrouped] autorelease];
    [faqTV setGeneralTableDataSource:[NSMutableArray arrayWithObject:secOne]];
    
    [self.contentView addSubview:faqTV];
    
}

@end
