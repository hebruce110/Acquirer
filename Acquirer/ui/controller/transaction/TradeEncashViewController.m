//
//  TradeEncashViewController.m
//  Acquirer
//
//  即时取现
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeEncashViewController.h"
#import "GeneralTableView.h"
#import "FormCellContent.h"
#import "PlainCellContent.h"
#import "FormTableCell.h"
#import "TradeEncashConfirmViewController.h"

@implementation EncashModel

@synthesize avlBalSTR, cashAmtSTR, miniAmtSTR;
@synthesize bankNameSTR, acctIdSTR, agentNameSTR;

-(void)dealloc{
    [avlBalSTR release];
    [cashAmtSTR release];
    [miniAmtSTR release];
    [bankNameSTR release];
    [acctIdSTR release];
    [agentNameSTR release];
    
    [super dealloc];
}

@end

@implementation TradeEncashViewController

@synthesize ec, encashTV;

-(void)dealloc{
    [ec release];
    [encashTV release];
    [encashList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        encashList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpEncashList{
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    
    FormCellContent *miniBalContent = [[[FormCellContent alloc] init] autorelease];
    miniBalContent.titleSTR = @"取现金额：";
    miniBalContent.titleFont = [UIFont boldSystemFontOfSize:16];
    
    miniBalContent.placeHolderSTR = [NSString stringWithFormat:@"最低取现金额为%@元", ec.miniAmtSTR];
    miniBalContent.textFont = [UIFont boldSystemFontOfSize:16];
    miniBalContent.textAlignment = NSTextAlignmentRight;
    
    miniBalContent.maxLength = 12;
    miniBalContent.keyboardType = UIKeyboardTypeDecimalPad;
    [secOne addObject:miniBalContent];
    
    PlainCellContent *bankContent = [[[PlainCellContent alloc] init] autorelease];
    bankContent.titleSTR = @"到账银行";
    bankContent.bgColor = [Helper hexStringToColor:@"#E8E8E8"];
    bankContent.textSTR = ec.bankNameSTR;
    bankContent.cellStyle = Cell_Style_Plain;
    [secOne addObject:bankContent];
    
    PlainCellContent *acctContent = [[[PlainCellContent alloc] init] autorelease];
    acctContent.titleSTR = @"到账帐户";
    acctContent.bgColor = [Helper hexStringToColor:@"#E8E8E8"];
    acctContent.textSTR = ec.acctIdSTR;
    [secOne addObject:acctContent];
    
    [encashList addObject:secOne];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"即时取现"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGFloat widthOffset = 20;
    UILabel *avlBalTitleLabel = [[UILabel alloc] init];
    avlBalTitleLabel.frame = CGRectMake(widthOffset, 20, 100, 20);
    avlBalTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    avlBalTitleLabel.backgroundColor = [UIColor clearColor];
    avlBalTitleLabel.textAlignment = NSTextAlignmentLeft;
    avlBalTitleLabel.text = @"可取金额：";
    [self.contentView addSubview:avlBalTitleLabel];
    [avlBalTitleLabel release];
    
    //金额
    CGFloat textWidth = 180;
    UILabel *avlBalTextLabel = [[UILabel alloc] init];
    avlBalTextLabel.frame = CGRectMake(contentWidth-widthOffset-25-textWidth, 20, textWidth, 20);
    avlBalTextLabel.font = [UIFont boldSystemFontOfSize:20];
    avlBalTextLabel.backgroundColor = [UIColor clearColor];
    avlBalTextLabel.textColor = [Helper amountRedColor];
    avlBalTextLabel.textAlignment = NSTextAlignmentRight;
    avlBalTextLabel.text = [Helper processAmtDisplay:ec.avlBalSTR];
    [self.contentView addSubview:avlBalTextLabel];
    [avlBalTextLabel release];
    
    //单位
    UILabel *avlUnitLabel = [[UILabel alloc] init];
    avlUnitLabel.frame = CGRectMake(contentWidth-widthOffset-20, 20, 20, 20);
    avlUnitLabel.font = [UIFont boldSystemFontOfSize:16];
    avlUnitLabel.backgroundColor = [UIColor clearColor];
    avlUnitLabel.textAlignment = NSTextAlignmentLeft;
    avlUnitLabel.text = @"元";
    [self.contentView addSubview:avlUnitLabel];
    [avlUnitLabel release];
    
    UILabel *cashAmtTitleLabel = [[UILabel alloc] init];
    cashAmtTitleLabel.frame = CGRectMake(widthOffset, 50, 120, 20);
    cashAmtTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    cashAmtTitleLabel.backgroundColor = [UIColor clearColor];
    cashAmtTitleLabel.textAlignment = NSTextAlignmentLeft;
    cashAmtTitleLabel.text = @"当日取现额度：";
    [self.contentView addSubview:cashAmtTitleLabel];
    [cashAmtTitleLabel release];
    
    UILabel *cashAmtTextLabel = [[UILabel alloc] init];
    cashAmtTextLabel.frame = CGRectMake(contentWidth-widthOffset-25-textWidth, 50, textWidth, 20);
    cashAmtTextLabel.font = [UIFont boldSystemFontOfSize:20];
    cashAmtTextLabel.backgroundColor = [UIColor clearColor];
    cashAmtTextLabel.textColor = [Helper amountRedColor];
    cashAmtTextLabel.textAlignment = NSTextAlignmentRight;
    cashAmtTextLabel.text = [Helper processAmtDisplay:ec.cashAmtSTR];
    [self.contentView addSubview:cashAmtTextLabel];
    [cashAmtTextLabel release];
    
    //单位
    UILabel *cashUnitLabel = [[UILabel alloc] init];
    cashUnitLabel.frame = CGRectMake(contentWidth-widthOffset-20, 50, 20, 20);
    cashUnitLabel.font = [UIFont boldSystemFontOfSize:16];
    cashUnitLabel.backgroundColor = [UIColor clearColor];
    cashUnitLabel.textAlignment = NSTextAlignmentLeft;
    cashUnitLabel.text = @"元";
    [self.contentView addSubview:cashUnitLabel];
    [cashUnitLabel release];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(cashAmtTitleLabel.frame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    [self setUpEncashList];
    
    CGRect encashTVFrame = CGRectMake(0, frameHeighOffset(dashFrame)+VERTICAL_PADDING/2, contentWidth, 150);
    self.encashTV = [[[GeneralTableView alloc] initWithFrame:encashTVFrame style:UITableViewStyleGrouped] autorelease];
    [encashTV setDelegateViewController:self];
    [encashTV setGeneralTableDataSource:encashList];
    encashTV.scrollEnabled = NO;
    [self.contentView addSubview:encashTV];
    
    CGRect dashFrame2 = CGRectMake(0, frameHeighOffset(encashTVFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView2 = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView2.frame = dashFrame2;
    dashImgView2.center = CGPointMake(self.contentView.center.x, dashImgView2.center.y);
    [self.contentView addSubview:dashImgView2];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(widthOffset, frameHeighOffset(dashFrame2)+VERTICAL_PADDING, 150, 20);
    tipLabel.font = [UIFont boldSystemFontOfSize:14];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.text = @"正常到账时间：2小时";
    [self.contentView addSubview:tipLabel];
    [tipLabel release];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(tipLabel.frame)+VERTICAL_PADDING, btnSelImg.size.width, btnSelImg.size.height);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(pressSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [contentView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    for (UITableViewCell *cell in [self.encashTV visibleCells]) {
        if ([cell isKindOfClass:FormTableCell.class]) {
            [((FormTableCell*)cell).textField resignFirstResponder];
        }
    }
}

-(Boolean)conformToAmtFormat:(NSString *)amtSTR{
    NSCharacterSet *splitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"."];
    
    NSRange dotRange = [amtSTR rangeOfCharacterFromSet:splitCharSet];
    if (dotRange.location == NSNotFound) {
        return YES;
    }else{
        int amtLength = [amtSTR length];
        if (amtLength-dotRange.length-dotRange.location > 2) {
            return NO;
        }
    }
    return YES;
}

-(void)pressSubmit:(id)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    FormTableCell *formCell = (FormTableCell *)[encashTV cellForRowAtIndexPath:indexPath];
    
    NSString *amtSTR = formCell.textField.text;
    if (amtSTR==nil || [amtSTR isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请输入取现金额" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    if ([self conformToAmtFormat:amtSTR] == NO) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"输入取款金额格式有误" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    float amt = [amtSTR floatValue];
    //最低取款金额
    float miniAmt = [ec.miniAmtSTR floatValue];
    if (amt < miniAmt) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"取款金额小于每笔最低取款金额" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    //可取款金额
    float cashAmt = [ec.cashAmtSTR floatValue];
    if (amt > cashAmt) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"取款金额大于当日取现额度" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }
    
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000021"];
    
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle:NSNumberFormatterNoStyle];
    [numFormatter setPositiveFormat:@"0.00"];
    NSString *amtFormatSTR = [numFormatter stringFromNumber:[NSNumber numberWithFloat:[amtSTR floatValue]]];
    
    [[AcquirerService sharedInstance].encashService onRespondTarget:self];
    [[AcquirerService sharedInstance].encashService requestForEncashImmediately:amtFormatSTR];
}

-(void)processEncashImmediatelyData:(NSDictionary *)dict{
    ConfirmEncashModel *ce = [[[ConfirmEncashModel alloc] init] autorelease];
    ce.bankNameSTR = [dict objectForKey:@"bankName"];
    ce.acctIdSTR = [dict objectForKey:@"acctId"];
    ce.cashAmtSTR = [dict objectForKey:@"cashAmt"];
    ce.feeAmtSTR = [dict objectForKey:@"feeAmt"];
    ce.acctAmt = [dict objectForKey:@"acctAmt"];
    
    TradeEncashConfirmViewController *tradeEncashConfirmCTRL = [[TradeEncashConfirmViewController new] autorelease];
    tradeEncashConfirmCTRL.ceModel = ce;
    [self.navigationController pushViewController:tradeEncashConfirmCTRL animated:YES];
}

@end













