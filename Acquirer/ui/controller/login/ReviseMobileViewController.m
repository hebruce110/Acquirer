
//
//  ReviseMobileViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-13.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ReviseMobileViewController.h"
#import "GeneralTableView.h"
#import "FormCellContent.h"
#import "FormTableCell.h"

@interface ReviseMobileViewController ()

@end

@implementation ReviseMobileViewController

@synthesize submitBtn, pnrDevIdSTR, mobileTableView;

-(void)dealloc{
    [pnrDevIdSTR release];
    [mobileTableView release];
    
    [submitBtn release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"手机号提交"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    
    CGRect introFrame = introFrame =  CGRectMake(20, 20, 280, 20);
    UILabel *introMsgLabel = [[[UILabel alloc] initWithFrame:introFrame] autorelease];
    introMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introMsgLabel.numberOfLines = 2;
    introMsgLabel.font = [UIFont systemFontOfSize:16];
    introMsgLabel.text = [NSString stringWithFormat:@"订单号前8位：%@", pnrDevIdSTR] ;
    introMsgLabel.backgroundColor = [UIColor clearColor];
    introMsgLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:introMsgLabel];
    
    NSMutableArray *patternList = [[[NSMutableArray alloc] init] autorelease];
    FormCellContent *mobilePattern = [[[FormCellContent alloc] init] autorelease];
    mobilePattern.titleSTR = @"手机号：";
    mobilePattern.placeHolderSTR = @"您现在使用的手机号";
    mobilePattern.maxLength = 11;
    mobilePattern.keyboardType = UIKeyboardTypeNumberPad;
    [patternList addObject:mobilePattern];
    
    CGRect mobileFrame = CGRectMake(0, 50, contentWidth, 60);
    self.mobileTableView = [[[GeneralTableView alloc] initWithFrame:mobileFrame style:UITableViewStyleGrouped] autorelease];
    mobileTableView.scrollEnabled = NO;
    mobileTableView.backgroundColor = [UIColor clearColor];
    mobileTableView.backgroundView = nil;
    [self.contentView addSubview:mobileTableView];
    [mobileTableView setGeneralTableDataSource:[NSMutableArray arrayWithObject:patternList]];
    [mobileTableView setDelegateViewController:self];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(mobileFrame)+VERTICAL_PADDING*2, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UIImage *btnRSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnRDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, frameHeighOffset(dashImgView.frame)+VERTICAL_PADDING*2, btnRSelImg.size.width, btnRSelImg.size.height);
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnRDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnRSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.bgImageView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];
    
    if ([touchView isDescendantOfView:self.mobileTableView]) {
        return NO;
    }
    return YES;
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    
    for (FormTableCell *cell in [self.mobileTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

-(void)submit:(id)sender{
    
    NSString *newMobileSTR = ((FormTableCell *)[[self.mobileTableView visibleCells] objectAtIndex:0]).textField.text;
    
    //check 
    if ([Helper stringNullOrEmpty:newMobileSTR] || newMobileSTR.length!=11) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"手机号格式有误，请重新输入"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
    }
    
    [[AcquirerService sharedInstance].valiService onRespondTarget:self];
    [[AcquirerService sharedInstance].valiService requestForNewMobile:newMobileSTR withPNRDevId:pnrDevIdSTR];
}

@end
