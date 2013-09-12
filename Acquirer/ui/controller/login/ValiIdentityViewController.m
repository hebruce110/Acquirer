//
//  ValiIdentityViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ValiIdentityViewController.h"
#import "FormCellPattern.h"
#import "FormTableCell.h"

@interface ValiIdentityViewController ()

@end

@implementation ValiIdentityViewController

@synthesize bgScrollView;
@synthesize posOrderTableView, captchaTableView;
@synthesize authImgView;

-(void)dealloc{
    [bgScrollView release];
    
    [posOrderTableView release];
    [captchaTableView release];
    
    [authImgView release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        isShowNaviBar = YES;
        isShowTabBar = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"身份验证"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.bgScrollView = [[[UIScrollView alloc] initWithFrame:self.contentView.frame] autorelease];
    [self.bgImageView addSubview:bgScrollView];
    
    //remove contentView
    [self.contentView removeFromSuperview];
    contentView.frame = contentView.bounds;
    [bgScrollView addSubview:contentView];
    
    FormCellPattern *posPattern = [[[FormCellPattern alloc] init] autorelease];
    posPattern.titleSTR = @"订单号前8位：";
    posPattern.placeHolderSTR = @"POS小票订单号前8位";
    posPattern.maxLength = 8;
    posPattern.keyboardType = UIKeyboardTypeNumberPad;
    NSMutableArray *posPatternList = [[[NSMutableArray alloc] init] autorelease];
    [posPatternList addObject:posPattern];
    
    CGRect posOrdertableFrame = CGRectMake(0, 10, contentWidth, 60);
    self.posOrderTableView = [[[FormTableView alloc] initWithFrame:posOrdertableFrame style:UITableViewStyleGrouped] autorelease];
    posOrderTableView.scrollEnabled = NO;
    posOrderTableView.backgroundColor = [UIColor clearColor];
    posOrderTableView.backgroundView = nil;
    [self.contentView addSubview:posOrderTableView];
    //posOrderTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), posOrderTableView.center.y);
    [posOrderTableView setFormTableDataSource:posPatternList];
    
    UIImage *orderEgImg = [UIImage imageNamed:@"order_eg.png"];
    UIImageView *orderEgImgView = [[[UIImageView alloc] initWithImage:orderEgImg] autorelease];
    orderEgImgView.frame = CGRectMake(0, 80, orderEgImg.size.width, orderEgImg.size.height);
    orderEgImgView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), orderEgImgView.center.y);
    [self.contentView addSubview:orderEgImgView];
    
    FormCellPattern *captchaPattern = [[[FormCellPattern alloc] init] autorelease];
    captchaPattern.titleSTR = @"验证码：";
    captchaPattern.placeHolderSTR = @"验证码";
    captchaPattern.maxLength = 4;
    captchaPattern.keyboardType = UIKeyboardTypeAlphabet;
    captchaPattern.scrollOffset = CGPointMake(0, 100);
    NSMutableArray *captchaPatternList = [[[NSMutableArray alloc] init] autorelease];
    [captchaPatternList addObject:captchaPattern];
    
    CGRect tableFrame = CGRectMake(0, 220, 170, 60);
    self.captchaTableView = [[[FormTableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    captchaTableView.scrollEnabled = NO;
    captchaTableView.backgroundColor = [UIColor clearColor];
    captchaTableView.backgroundView = nil;
    [self.contentView addSubview:captchaTableView];
    [captchaTableView setFormTableDataSource:captchaPatternList];
    [captchaTableView setDelegateViewController:self];
    
    UIImage *authImg = [UIImage imageNamed:@"auth_loading.png"];
    self.authImgView = [[[UIImageView alloc] initWithImage:authImg] autorelease];
    authImgView.userInteractionEnabled = YES;
    authImgView.frame = CGRectMake(190, 0, authImg.size.width, authImg.size.height);
    authImgView.center = CGPointMake(authImgView.center.x, captchaTableView.center.y);
    [self.contentView addSubview:authImgView];
    
    UILabel *descLabel = [[[UILabel alloc] init] autorelease];
    descLabel.bounds = CGRectMake(0, 0, 85, 20);
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.text = @"点击图片刷新";
    [self.contentView addSubview:descLabel];
    descLabel.center = CGPointMake(authImgView.center.x, authImgView.center.y+35);
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(descLabel.frame)+VERTICAL_PADDING,
                                  dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    UIImage *btnRSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnRDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, frameHeighOffset(dashImgView.frame)+VERTICAL_PADDING*2, btnRSelImg.size.width, btnRSelImg.size.height);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnRDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnRSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.authImgView addGestureRecognizer:tg];
    [self.bgImageView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[AcquirerService sharedInstance].valiService onRespondTarget:self];
    [[AcquirerService sharedInstance].valiService requestForAuthImgURL];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];

    if ([touchView isDescendantOfView:self.posOrderTableView] || [touchView isDescendantOfView:self.captchaTableView]) {
        return NO;
    }
    return YES;
}

-(void) tapGesture:(UITapGestureRecognizer *)sender{
    CGPoint pointOfBg = [sender locationInView:self.bgImageView];
    CGPoint pointOfAuth = [self.authImgView convertPoint:pointOfBg fromView:self.bgImageView];
    
    if (CGRectContainsPoint(authImgView.bounds, pointOfAuth)) {
        [[AcquirerService sharedInstance].valiService onRespondTarget:self];
        [[AcquirerService sharedInstance].valiService requestForAuthImgURL];
        return;
    }
    
    for (FormTableCell *cell in [self.posOrderTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
    for (FormTableCell *cell in [self.captchaTableView visibleCells]) {
        [cell.textField resignFirstResponder];
    }
}

-(void)refreshAuthImgView:(NSData *)imgData{
    UIImage *img = [UIImage imageWithData:imgData];
    self.authImgView.image = img;
}

-(void)submit:(id)sender{
    NSString *posOrderIdSTR = ((FormTableCell *)[[posOrderTableView visibleCells] objectAtIndex:0]).textField.text;
    NSString *authCodeSTR = ((FormTableCell *)[[captchaTableView visibleCells] objectAtIndex:0]).textField.text;
    
    if ([Helper stringNullOrEmpty:posOrderIdSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"订单号为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([posOrderIdSTR length] < 8){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"订单号为8位，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
    }
    
    if ([Helper stringNullOrEmpty:authCodeSTR]) {
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"验证码为空，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
        return;
    }else if ([authCodeSTR length] != 4){
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"验证码为４位，请重新输入" notifyType:NOTIFICATION_TYPE_ERROR];
    }

    
}

-(void)pushToActivateViewController:(NSString *)mobileSTR{
    
}

static BOOL isShowTextEditing = NO;
-(void)adjustForTextFieldDidBeginEditing:(UITextField *)textField contentOffset:(CGPoint)offset{
    if (isShowTextEditing == NO) {
        [bgScrollView setContentOffset:offset animated:YES];
        isShowTextEditing = YES;
    }
}

-(void)adjustForTextFieldDidEndEditing:(UITextField *)textField contentOffset:(CGPoint)offset{
    isShowTextEditing = NO;
    [bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


@end
