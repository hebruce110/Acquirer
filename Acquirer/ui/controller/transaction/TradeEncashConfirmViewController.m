//
//  TradeEncashConfirmViewController.m
//  Acquirer
//
//  Created by peer on 10/28/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeEncashConfirmViewController.h"
#import "PlainCellContent.h"

@implementation ConfirmEncashModel

@synthesize bankNameSTR, acctIdSTR, cashAmtSTR;
@synthesize feeAmtSTR, acctAmt;

-(void)dealloc{
    [bankNameSTR release];
    [acctIdSTR release];
    [cashAmtSTR release];
    [feeAmtSTR release];
    [acctAmt release];
    
    [super dealloc];
}

@end

@implementation TradeEncashConfirmViewController

@synthesize ceModel, encashTV;

-(void)dealloc{
    [ceModel release];
    [encashList release];
    [encashTV release];
    
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
    NSMutableArray *secOne = [[NSMutableArray new] autorelease];
    
    PlainCellContent *cashContent = [[PlainCellContent new] autorelease];
    cashContent.titleSTR = @"取现金额：";
    cashContent.textSTR = ceModel.cashAmtSTR;
    cashContent.cellStyle = Cell_Style_Unit;
    [secOne addObject:cashContent];
    
    PlainCellContent *acctContent = [[PlainCellContent new] autorelease];
    acctContent.titleSTR = @"实际到账金额：";
    acctContent.textSTR = ceModel.acctAmt;
    acctContent.cellStyle = Cell_Style_Unit;
    [secOne addObject:acctContent];
    
    PlainCellContent *feeContent = [[PlainCellContent new] autorelease];
    feeContent.titleSTR = @"手续费：";
    feeContent.textSTR = ceModel.feeAmtSTR;
    feeContent.cellStyle = Cell_Style_Unit;
    [secOne addObject:feeContent];
    
    [encashList addObject:secOne];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"取现确认"];

    CGFloat offset = 20;
    CGFloat contentWidth = self.contentView.frame.size.width;

    [self setUpEncashList];
    self.encashTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWidth, 145)
                                                       style:UITableViewStyleGrouped] autorelease];
    [encashTV setGeneralTableDataSource:encashList];
    encashTV.scrollEnabled = NO;
    [self.contentView addSubview:encashTV];
    
    CGFloat chargeTextWidth = 100;
    CGRect chargeStandardFrame = CGRectMake(contentWidth-offset-chargeTextWidth, frameHeighOffset(encashTV.frame)+VERTICAL_PADDING, chargeTextWidth, 20);
    UIButton *chargeStandardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chargeStandardBtn.frame = chargeStandardFrame;
    chargeStandardBtn.backgroundColor = [UIColor clearColor];
    [chargeStandardBtn setTitle:@"收费标准" forState:UIControlStateNormal];
    [chargeStandardBtn setTitleColor:[UIColor colorWithRed:54/255.0 green:84/255.0 blue:138/255.0 alpha:1.0] forState:UIControlStateNormal];
    chargeStandardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    chargeStandardBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    chargeStandardBtn.contentHorizontalAlignment = NSTextAlignmentRight;
    [chargeStandardBtn addTarget:self action:@selector(pressChargeStandard:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:chargeStandardBtn];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(chargeStandardFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UILabel *acctBankTitleLabel = [[UILabel alloc] init];
    acctBankTitleLabel.frame = CGRectMake(offset, frameHeighOffset(dashFrame)+VERTICAL_PADDING, 100, 20);
    acctBankTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    acctBankTitleLabel.backgroundColor = [UIColor clearColor];
    acctBankTitleLabel.textAlignment = NSTextAlignmentLeft;
    acctBankTitleLabel.text = @"到账银行：";
    [self.contentView addSubview:acctBankTitleLabel];
    [acctBankTitleLabel release];
    
    UILabel *acctBankTextLabel = [[UILabel alloc] init];
    acctBankTextLabel.frame = CGRectMake(contentWidth-offset-200, frameHeighOffset(dashFrame)+VERTICAL_PADDING, 200, 20);
    acctBankTextLabel.font = [UIFont boldSystemFontOfSize:16];
    acctBankTextLabel.backgroundColor = [UIColor clearColor];
    acctBankTextLabel.textAlignment = NSTextAlignmentRight;
    acctBankTextLabel.text = ceModel.bankNameSTR;
    [self.contentView addSubview:acctBankTextLabel];
    [acctBankTextLabel release];
    
    UILabel *acctIdTitleLabel = [[UILabel alloc] init];
    acctIdTitleLabel.frame = CGRectMake(offset, frameHeighOffset(acctBankTitleLabel.frame)+VERTICAL_PADDING, 100, 20);
    acctIdTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    acctIdTitleLabel.backgroundColor = [UIColor clearColor];
    acctIdTitleLabel.textAlignment = NSTextAlignmentLeft;
    acctIdTitleLabel.text = @"到账账户";
    [self.contentView addSubview:acctIdTitleLabel];
    [acctIdTitleLabel release];
    
    UILabel *acctIdTextLabel = [[UILabel alloc] init];
    acctIdTextLabel.frame = CGRectMake(contentWidth-offset-200, frameHeighOffset(acctBankTitleLabel.frame)+VERTICAL_PADDING, 200, 20);
    acctIdTextLabel.font = [UIFont boldSystemFontOfSize:16];
    acctIdTextLabel.backgroundColor = [UIColor clearColor];
    acctIdTextLabel.textAlignment = NSTextAlignmentRight;
    acctIdTextLabel.text = ceModel.acctIdSTR;
    [self.contentView addSubview:acctIdTextLabel];
    [acctIdTextLabel release];
    
    CGRect dashFrame2 = CGRectMake(0, frameHeighOffset(acctIdTextLabel.frame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView2 = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView2.frame = dashFrame2;
    dashImgView2.center = CGPointMake(self.contentView.center.x, dashImgView2.center.y);
    [self.contentView addSubview:dashImgView2];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(offset, frameHeighOffset(dashFrame2)+VERTICAL_PADDING, contentWidth-offset*2, 40);
    tipLabel.font = [UIFont boldSystemFontOfSize:15];
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.textColor = [Helper amountRedColor];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentNatural;
    tipLabel.text = @"提示：若当日消费撤销金额大于未结算金额，POS可能无法完成消费撤销交易";
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
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(pressConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
}

-(void)pressChargeStandard:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收费标准" message:@"手续费＝取现金额－手续费率\n该标准由当地服务商设定，若有疑问请联系当地服务商" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
    [alertView show];
    [alertView release];
}

-(void)pressConfirm:(id)sender{
    
}


@end
