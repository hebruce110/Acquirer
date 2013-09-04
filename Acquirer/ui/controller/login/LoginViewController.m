//
//  LoginViewController.m
//  Acquirer
//
//  Created by chinapnr on 13-9-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginTableCell.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginTableView;

-(void)dealloc{
    [loginTableView release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = NO;
        self.isShowTabBar = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *loginBgImg = IS_IPHONE5 ? [UIImage imageNamed:@"sd_logo-568h@2x.png"]:[UIImage imageNamed:@"sd_logo"];
    UIImageView *loginBgImgView = [[[UIImageView alloc] init] autorelease];
    loginBgImgView.userInteractionEnabled = YES;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.frame = self.bgImageView.bounds;
    loginBgImgView.image = loginBgImg;
    
    [self.bgImageView addSubview:loginBgImgView];
    [self.bgImageView sendSubviewToBack:loginBgImgView];
    
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    CGRect tableFrame = CGRectMake(0, 90, 300, 160);
    self.loginTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    loginTableView.backgroundColor = [UIColor clearColor];
    loginTableView.backgroundView = nil;
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    [self.contentView addSubview:loginTableView];
    loginTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginTableView.center.y);
    
    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [contentView addGestureRecognizer:tg];
    tg.delegate = self;
    [tg release];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.contentView];
    CGPoint convertPoint = [self.loginTableView convertPoint:point fromView:contentView];
    
    if (CGRectContainsPoint(self.loginTableView.bounds, convertPoint)) {
        return NO;
    }
    return YES;
}

//处理选中事件
-(void) tapGesture:(UITapGestureRecognizer *)sender{
    for (LoginTableCell *cell in [self.loginTableView visibleCells]) {
        [cell.contentTextField resignFirstResponder];
    }
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
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"机  构  号　|";
            [cell.contentTextField setPlaceholder:@"请输入机构号"];
            [cell.contentTextField setKeyboardType:UIKeyboardTypeNumberPad];
            break;
        case 1:
            cell.titleLabel.text = @"操作员号　|";
            cell.contentTextField.placeholder = @"请输入操作员号";
            [cell.contentTextField setKeyboardType:UIKeyboardTypeAlphabet];
            break;
        case 2:
            cell.titleLabel.text = @"密　　码　|";
            cell.contentTextField.placeholder = @"请输入密码";
            cell.contentTextField.returnKeyType = UIReturnKeyDone;
            cell.contentTextField.secureTextEntry = YES;
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}






















@end
