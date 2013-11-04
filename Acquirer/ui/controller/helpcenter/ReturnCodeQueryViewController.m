//
//  ReturnCodeQueryViewController.m
//  Acquirer
//
//  Created by peer on 11/1/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "ReturnCodeQueryViewController.h"
#import "PlainCellContent.h"
#import "GeneralTableView.h"
#import "PlainTableCell.h"
#import "Acquirer.h"
#import "ActionSheetStringPicker.h"

@implementation ReturnCodeQueryViewController

@synthesize codeTV, codeDescTextView;
@synthesize stringPicker;

-(void)dealloc{
    [codeList release];
    [codeTV release];
    [codeDescTextView release];
    [stringPicker release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        codeList = [[NSMutableArray alloc] init];
        
        for (CodeInfo *info in [Acquirer sharedInstance].codeList) {
            if ([info.codeTypeSTR isEqualToString:@"1"]) {
                [codeList addObject:info.codeNumSTR];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"刷卡返回码查询"];
    
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    PlainCellContent *pc = [[PlainCellContent new] autorelease];
    pc.titleSTR = @"返回码";
    pc.textSTR = @"23";
    pc.cellStyle = Cell_Style_Plain;
    [secOne addObject:pc];
    
    self.codeTV = [[GeneralTableView alloc] initWithFrame:CGRectMake(0, 20, self.contentView.bounds.size.width, 60)
                                                    style:UITableViewStyleGrouped];
    [codeTV setDelegateViewController:self];
    [codeTV setGeneralTableDataSource:[NSMutableArray arrayWithObject:secOne]];
    [self.contentView addSubview:codeTV];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(codeTV.frame)+VERTICAL_PADDING, btnSelImg.size.width, btnSelImg.size.height);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"查询" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(pressQuery:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    
    CGFloat offset = 10;
    
    self.codeDescTextView = [[[UITextView alloc] init] autorelease];
    codeDescTextView.frame = CGRectMake(offset,
                                        frameHeighOffset(buttonFrame)+VERTICAL_PADDING*2,
                                        self.contentView.bounds.size.width-offset*2,
                                        200);
    codeDescTextView.textColor = [UIColor blackColor];
    codeDescTextView.font = [UIFont boldSystemFontOfSize:16];
    codeDescTextView.backgroundColor = [UIColor whiteColor];
    codeDescTextView.scrollEnabled = NO;
    codeDescTextView.editable = NO;
    codeDescTextView.layer.borderColor = [UIColor grayColor].CGColor;
    codeDescTextView.layer.borderWidth = 2.0;
    codeDescTextView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:codeDescTextView];
    
}


- (void)devWasSelected:(NSNumber *)selectedIndex element:(id)element {
    NSString *codeSTR = [codeList objectAtIndex:[selectedIndex intValue]];
    
    PlainTableCell *cell = (PlainTableCell *) [codeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text = codeSTR;
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 && indexPath.section==0) {
        self.stringPicker = [[[ActionSheetStringPicker alloc] initWithTitle:@"" rows:codeList initialSelection:0 target:self successAction:@selector(devWasSelected:element:) cancelAction:nil origin:self.contentView] autorelease];
        [stringPicker showActionSheetPicker];
    }
}

-(void)pressQuery:(id)sender{
    PlainTableCell *cell = (PlainTableCell *)[codeTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    codeDescTextView.text = [[Acquirer sharedInstance] codeCSVDesc:cell.textLabel.text];
}

@end
