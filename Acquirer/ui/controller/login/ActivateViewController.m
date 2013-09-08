//
//  ActivateViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-6.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "ActivateViewController.h"
#import "LoginTableCell.h"

@interface ActivateViewController ()

@end

@implementation ActivateViewController

@synthesize bgScrollView;
@synthesize mobileSTR, activateTableView;

-(void)dealloc{
    [bgScrollView release];
    [activateTableView release];
    [mobileSTR release];
    
    [super dealloc];
}


-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        
        contentList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpContentList{
    NSArray *titleList = [NSArray arrayWithObjects:@"短信激活码：", @"新密码：", @"确认新密码：", nil];
    NSArray *placeHolderList = [NSArray arrayWithObjects:@"发送至手机的激活码", @"密码由6-20个字母、数字组成", @"再次输入新密码", nil];
    NSArray *keyboardTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:UIKeyboardTypeNumberPad],
                                 [NSNumber numberWithInt:UIKeyboardTypeAlphabet],
                                 [NSNumber numberWithInt:UIKeyboardTypeAlphabet],nil];
    NSArray *secureList = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                           [NSNumber numberWithBool:YES],
                           [NSNumber numberWithBool:YES], nil];
    NSArray *maxLengthList = [NSArray arrayWithObjects:[NSNumber numberWithInt:6],
                              [NSNumber numberWithInt:20],
                              [NSNumber numberWithInt:20],nil];
    
    for (int i=0; i<[titleList count]; i++) {
        LoginCellContent *content = [[[LoginCellContent alloc] init] autorelease];
        content.titleSTR = [titleList objectAtIndex:i];
        content.placeHolderSTR = [placeHolderList objectAtIndex:i];
        content.keyboardType = [[keyboardTypeList objectAtIndex:i] integerValue];
        content.secure = [[secureList objectAtIndex:i] boolValue];
        content.maxLength = [[maxLengthList objectAtIndex:i] integerValue];
        [contentList addObject:content];
    }
}

#define VERTICAL_PADDING 10

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNavigationTitle:@"账号激活"];
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    //CGFloat contentHeight = self.contentView.bounds.size.height;
    
    self.bgScrollView = [[[UIScrollView alloc] initWithFrame:self.contentView.frame] autorelease];
    [self.bgImageView addSubview:bgScrollView];
    
    //remove contentView
    [self.contentView removeFromSuperview];
    contentView.frame = contentView.bounds;
    [bgScrollView addSubview:contentView];
    
    CGRect introFrame = CGRectMake(20, 10, 280, 40);
    UILabel *introMsgLabel = [[[UILabel alloc] initWithFrame:introFrame] autorelease];
    introMsgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    introMsgLabel.numberOfLines = 2;
    introMsgLabel.font = [UIFont systemFontOfSize:16];
    introMsgLabel.text = @"账号未激活,请输入以下信息，验证通过后可正常使用。";
    introMsgLabel.backgroundColor = [UIColor clearColor];
    introMsgLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:introMsgLabel];
    
    CGRect mobileFrame = CGRectMake(20, frameHeighOffset(introFrame)+VERTICAL_PADDING-5, 200, 20);
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:mobileFrame];
    mobileLabel.font = [UIFont systemFontOfSize:16];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.textAlignment = NSTextAlignmentLeft;
    mobileLabel.text = [NSString stringWithFormat:@"手机号：%@", mobileSTR];
    [self.contentView addSubview:mobileLabel];
    
    CGRect hintFrame = CGRectMake(20, frameHeighOffset(mobileFrame)+VERTICAL_PADDING-5, 280, 25);
    UILabel *hintMsgLabel = [[UILabel alloc] initWithFrame:hintFrame];
    hintMsgLabel.font = [UIFont boldSystemFontOfSize:13];
    hintMsgLabel.backgroundColor = [UIColor clearColor];
    hintMsgLabel.textAlignment = NSTextAlignmentLeft;
    hintMsgLabel.text = [NSString stringWithFormat:@"提示：该手机号是签订POS协议时预留的号码"];
    hintMsgLabel.textColor = [Helper hexStringToColor:@"#CC0000"];
    [self.contentView addSubview:hintMsgLabel];
    
    UIImage *btnWSelImg = [UIImage imageNamed:@"BUTT_whi_on.png"];
    UIImage *btnWDeSelImg = [UIImage imageNamed:@"BUTT_whi_off.png"];
    CGRect activateFrame = CGRectMake(0, frameHeighOffset(hintFrame)+VERTICAL_PADDING, btnWSelImg.size.width, btnWSelImg.size.height);
    
    UIButton *activateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activateBtn.frame = activateFrame;
    activateBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), activateBtn.center.y);
    activateBtn.backgroundColor = [UIColor clearColor];
    [activateBtn setBackgroundImage:btnWDeSelImg forState:UIControlStateNormal];
    [activateBtn setBackgroundImage:btnWSelImg forState:UIControlStateSelected];
    activateBtn.layer.cornerRadius = 10.0;
    activateBtn.clipsToBounds = YES;
    activateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17]; //[UIFont fontWithName:@"Arial" size:22];
    [activateBtn setTitle:@"获取激活码" forState:UIControlStateNormal];
    
    [activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [activateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [activateBtn addTarget:self action:@selector(retriveActivateCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:activateBtn];
    
    UIImage *dashImg = [UIImage imageNamed:@"dashed.png"];
    CGRect dashFrame = CGRectMake(0, frameHeighOffset(activateFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    UIImageView *dashImgView = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgView.frame = dashFrame;
    dashImgView.center = CGPointMake(self.contentView.center.x, dashImgView.center.y);
    [self.contentView addSubview:dashImgView];
    
    CGRect tableFrame = CGRectMake(0, frameHeighOffset(dashFrame)+VERTICAL_PADDING-5, contentWidth, 150);
    self.activateTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    activateTableView.scrollEnabled = NO;
    activateTableView.backgroundColor = [UIColor clearColor];
    activateTableView.backgroundView = nil;
    activateTableView.delegate = self;
    activateTableView.dataSource = self;
    [self.contentView addSubview:activateTableView];
    [self setUpContentList];
    
    UIImageView *dashImgViewCopy = [[[UIImageView alloc] initWithImage:dashImg] autorelease];
    dashImgViewCopy.frame = CGRectMake(0, frameHeighOffset(tableFrame)+VERTICAL_PADDING, dashImg.size.width, dashImg.size.height);
    dashImgViewCopy.center = CGPointMake(self.contentView.center.x, dashImgViewCopy.center.y);
    [self.contentView addSubview:dashImgViewCopy];
    
    UIImage *btnRSelImg = [UIImage imageNamed:@"BUTT_red_on.png"];
    UIImage *btnRDeSelImg = [UIImage imageNamed:@"BUTT_red_off.png"];
    CGRect buttonFrame = CGRectMake(0, frameHeighOffset(dashImgViewCopy.frame)+VERTICAL_PADDING, btnRSelImg.size.width, btnRSelImg.size.height);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = buttonFrame;
    submitBtn.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), submitBtn.center.y);
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setBackgroundImage:btnRDeSelImg forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:btnRSelImg forState:UIControlStateSelected];
    submitBtn.layer.cornerRadius = 10.0;
    submitBtn.clipsToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:22]; //[UIFont fontWithName:@"Arial" size:22];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
}

-(void)retriveActivateCode:(id)sender{
    
    
}

static BOOL isShowTextEditing = NO;
-(void)adjustForTextFieldDidBeginEditing:(UITextField *)textField{
    if (isShowTextEditing == NO) {
        bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+80);
        [bgScrollView setContentOffset:CGPointMake(0, 105) animated:YES];
        isShowTextEditing = YES;
    }
}

-(BOOL)adjustForTextFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyDone) {
        isShowTextEditing = NO;
        bgScrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
    }
    return YES;
}


#pragma mark UITableViewDataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Login_Identifier";
    
    LoginTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[[LoginTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContent:[contentList objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    [cell adjustForActivateViewController];
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end











