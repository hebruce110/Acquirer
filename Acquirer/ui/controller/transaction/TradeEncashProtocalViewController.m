//
//  TradeEncashProtocalViewController.m
//  Acquirer
//
//  Created by peer on 10/23/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "TradeEncashProtocalViewController.h"
#import "CustomTextView.h"
#import "TradeEncashViewController.h"

@implementation TradeEncashProtocalViewController

-(id)init{
    self = [super init];
    if (self) {
        hasReadAll = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"POS即时取现协议"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeigh = self.contentView.bounds.size.height;
    CGFloat textOffset = 10;
    
    //显示注册协议文字TextView
    CGRect textFrame = CGRectMake(textOffset, 10, contentWidth-2*textOffset, contentHeigh-100);
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:textFrame];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = YES;
    ((UIScrollView *)textView).delegate = self;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EncashAgreement" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    textView.text = content;
    [self.contentView addSubview:textView];
    
    //add dash view
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(textFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UIImage *btnSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(10, frameHeighOffset(dashFrame)+VERTICAL_PADDING, btnSelImg.size.width, btnSelImg.size.height);
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = buttonFrame;
    agreeBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), agreeBtn.center.y);
    agreeBtn.backgroundColor = [UIColor clearColor];
    [agreeBtn setBackgroundImage:btnDeSelImg forState:UIControlStateNormal];
    [agreeBtn setBackgroundImage:btnSelImg forState:UIControlStateSelected];
    agreeBtn.layer.cornerRadius = 10.0;
    agreeBtn.clipsToBounds = YES;
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [agreeBtn setTitle:@"同意协议" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(pressAgreeProtocal:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:agreeBtn];
    
}

#pragma mark UIScrollViewDelegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height) {
        hasReadAll = YES;
    }
}

-(void)pressAgreeProtocal:(id)sender{
    if (hasReadAll) {
        [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000020"];
        
        [[AcquirerService sharedInstance].encashService onRespondTarget:self];
        [[AcquirerService sharedInstance].encashService requestForProtocalAgreement];
        return ;
    }
    
    //协议没有阅读完成
    [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"请下滑阅读完POS即时取现协议!" notifyType:NOTIFICATION_TYPE_WARNING];
}

-(void)processProtocalEncashData:(NSDictionary *)dict{
    EncashModel *em = [[[EncashModel alloc] init] autorelease];
    em.cashAmtSTR = [dict objectForKey:@"cashAmt"];
    em.avlBalSTR = [dict objectForKey:@"avlBal"];
    em.miniAmtSTR = [dict objectForKey:@"minAmt"];
    em.bankNameSTR = [dict objectForKey:@"bankName"];
    em.acctIdSTR = [dict objectForKey:@"acctId"];
    em.agentNameSTR = [dict objectForKey:@"agentName"];
    
    TradeEncashViewController *teCTRL = [[[TradeEncashViewController alloc] init] autorelease];
    teCTRL.ec = em;
    [self.navigationController pushViewController:teCTRL animated:YES];
}

@end
