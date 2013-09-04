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
    [contentList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self != nil) {
        self.isShowNaviBar = NO;
        self.isShowTabBar = NO;
        
        contentList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setUpContentList{
    NSArray *titleList = [NSArray arrayWithObjects:@"机  构  号　|", @"操作员号　|", @"密　　码　|", nil];
    NSArray *placeHolderList = [NSArray arrayWithObjects:@"请输入机构号", @"请输入操作员号", @"请输入密码", nil];
    NSArray *keyboardTypeList = [NSArray arrayWithObjects:[NSNumber numberWithInt:UIKeyboardTypeNumberPad],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],
                                                          [NSNumber numberWithInt:UIKeyboardTypeAlphabet],nil];
    NSArray *secureList = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:NO],
                                                    [NSNumber numberWithBool:YES], nil];
    NSArray *maxLengthList = [NSArray arrayWithObjects:[NSNumber numberWithInt:8],
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
    
    /*
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    */
     
    CGRect tableFrame = CGRectMake(0, 90, 300, 160);
    self.loginTableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    loginTableView.scrollEnabled = NO;
    loginTableView.backgroundColor = [UIColor clearColor];
    loginTableView.backgroundView = nil;
    loginTableView.delegate = self;
    loginTableView.dataSource = self;
    [self.contentView addSubview:loginTableView];
    loginTableView.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), loginTableView.center.y);
    
    [self setUpContentList];
    
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setContent:[contentList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark UITableViewDelegate Method

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}






















@end
