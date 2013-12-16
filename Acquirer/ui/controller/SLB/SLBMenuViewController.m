//
//  SLBMenuViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "TradeHomeViewController.h"
#import "SLBMenuViewController.h"
#import "SLBDetailListViewController.h"
#import "SLBUserNotiDocViewController.h"
#import "SLBDepositViewController.h"
#import "SLBTakeOutViewController.h"
#import "SLBMenuTopCell.h"
#import "SLBMenuAttributedCell.h"
#import "SLBService.h"
#import "SLBHelper.h"

@interface SLBMenuViewController () <UITableViewDelegate, UITableViewDataSource, SLBMenuTopCellDelegate>

@property (retain, nonatomic) SLBMenuTopCell *topCell;
@property (retain, nonatomic) UITableView *infoTableView;
@property (retain, nonatomic) UIButton *depositButton;
@property (retain, nonatomic) UIButton *takeOutButton;

@property (assign, nonatomic) CGFloat settleFund;
@property (assign, nonatomic) CGFloat totalAsset;
@property (assign, nonatomic) CGFloat totalProfit;

@end

@implementation SLBMenuViewController

- (void)dealloc
{
    self.topCell = nil;
    self.infoTableView = nil;
    self.depositButton = nil;
    self.takeOutButton = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isShowNaviBar = YES;
        self.isShowTabBar = NO;
        self.isShowRefreshBtn = NO;
        self.isNeedfresh = NO;
        
        _topCell = nil;
        _infoTableView = nil;
        _depositButton = nil;
        _takeOutButton = nil;
        
        _settleFund = 0;
        _totalAsset = 0;
        _totalProfit = 0;
        _isBackToMenuControl = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"生利宝"];
    
    [self addRightItem];
    [self addTopCell];
    
    CGSize ctSize = self.contentView.bounds.size;

    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topCell.frame), ctSize.width, 196.0f) style:UITableViewStyleGrouped];
    _infoTableView.backgroundView = nil;
    _infoTableView.backgroundColor = [UIColor clearColor];
    _infoTableView.dataSource = self;
    _infoTableView.delegate = self;
    _infoTableView.scrollEnabled = NO;
    [self.contentView addSubview:_infoTableView];
    
    CGFloat space = 8.0f;
    _depositButton = [[UIButton alloc] initWithFrame:CGRectMake(0, space + CGRectGetMaxY(_infoTableView.frame), 300.0f, 57.0f)];
    _takeOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, space + CGRectGetMaxY(_depositButton.frame), 300.0f, 57.0f)];
    
    _depositButton.center = CGPointMake(CGRectGetMidX(self.contentView.frame), _depositButton.center.y);
    _takeOutButton.center = CGPointMake(CGRectGetMidX(self.contentView.frame), _takeOutButton.center.y);
    
    [_depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_depositButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    
    [_takeOutButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_off"] forState:UIControlStateNormal];
    [_takeOutButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateHighlighted];
    [_takeOutButton setBackgroundImage:[UIImage imageNamed:@"BUTT_whi_on"] forState:UIControlStateSelected];
    
    _takeOutButton.layer.cornerRadius = _depositButton.layer.cornerRadius = 5.0f;
    _takeOutButton.clipsToBounds = _depositButton.clipsToBounds = YES;
    _takeOutButton.titleLabel.font = _depositButton.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [_depositButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_takeOutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_depositButton setTitle:@"存入生利宝" forState:UIControlStateNormal];
    [_takeOutButton setTitle:@"转出生利宝" forState:UIControlStateNormal];
    
    [_depositButton addTarget:self action:@selector(depositButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_takeOutButton addTarget:self action:@selector(takeOutButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_depositButton];
    [self.contentView addSubview:_takeOutButton];
    
    [self freshData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isNeedfresh) {
        self.isNeedfresh = NO;
        [self updateSLBUserInfo];
    }
}

- (void)freshData
{
    SLBUser *usr = [SLBService sharedService].slbUser;
    
    _settleFund = [[usr safeObjectForKey:@"settleFund"] floatValue];
    _totalAsset = [[usr safeObjectForKey:@"totalAsset"] floatValue];
    _totalProfit = [[usr safeObjectForKey:@"totalProfit"] floatValue];
    
    [_infoTableView reloadData];
}

- (void)updateSLBUserInfo
{
    [[SLBService sharedService].querySer requestForQueryTarget:self action:@selector(updateSLBUserInfoDidFinished)];
}

- (void)updateSLBUserInfoDidFinished
{
    [self freshData];
}

- (void)addRightItem
{
    UIImage *rightItemImg = [UIImage imageNamed:@"nav-btn.png"];
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightItemButton setBackgroundImage:[rightItemImg resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 6.0f, 10.0f, 6.0f)]
                          forState:UIControlStateNormal];
    rightItemButton.frame = CGRectMake(self.naviBgView.bounds.size.width - 70.0f, 0, 60.0f, 29.0f);
    rightItemButton.center = CGPointMake(rightItemButton.center.x, CGRectGetMidY(naviBgView.bounds));
    [rightItemButton setTitle:@"明细" forState:UIControlStateNormal];
    [rightItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItemButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightItemButton addTarget:self action:@selector(rightItemButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBgView addSubview:rightItemButton];
}

- (void)addTopCell
{
    CGSize ctSize = self.contentView.bounds.size;
    
    _topCell = [[SLBMenuTopCell alloc] init];
    _topCell.delegate = self;
    _topCell.frame = CGRectMake(0, 0, ctSize.width, 80.0f);
    _topCell.selectionStyle = UITableViewCellSelectionStyleGray;
    _topCell.backgroundColor = [UIColor clearColor];
    [_topCell setBackgroundImage:[UIImage imageNamed:@"infoshenglibao"]];
    [self.contentView addSubview:_topCell];
}

- (void)backToPreviousView:(id)sender
{
    if(!_isBackToMenuControl) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    TradeHomeViewController *tradeHomeViewCtrl = nil;
    for(id ctrl in self.navigationController.viewControllers) {
        if([ctrl isKindOfClass:[TradeHomeViewController class]]) {
            tradeHomeViewCtrl = ctrl;
            break;
        }
    }
    
    if(tradeHomeViewCtrl) {
        [self.navigationController popToViewController:tradeHomeViewCtrl animated:YES];
    }
    else {
        tradeHomeViewCtrl = [[TradeHomeViewController alloc] init];
        NSMutableArray *mtlViewCtrls = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mtlViewCtrls insertObject:tradeHomeViewCtrl atIndex:0];
        [tradeHomeViewCtrl release];
        [self.navigationController setViewControllers:mtlViewCtrls animated:NO];
        [self.navigationController popToViewController:tradeHomeViewCtrl animated:YES];
    }
}

- (void)rightItemButtonTouched:(id)sender
{
    //统计码:00000026
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000026"];
    
    SLBDetailListViewController *slbDetailListViewCtrl = [[SLBDetailListViewController alloc] init];
    [self.navigationController pushViewController:slbDetailListViewCtrl animated:YES];
    [slbDetailListViewCtrl release];
}

- (void)depositButtonTouched:(id)sender
{
    //统计码:00000027
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000027"];
    
    SLBDepositViewController *depositViewCtrl = [[SLBDepositViewController alloc] init];
    [self.navigationController pushViewController:depositViewCtrl animated:YES];
    [depositViewCtrl release];
}

- (void)takeOutButtonTouched:(id)sender
{
    //统计码:00000029
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000029"];
    
    SLBTakeOutViewController *takeOutViewCtrl = [[SLBTakeOutViewController alloc] init];
    [self.navigationController pushViewController:takeOutViewCtrl animated:YES];
    [takeOutViewCtrl release];
}

#pragma mark - SLBMenuTopCellDelegate

- (void)slbCellDidSelected:(SLBMenuTopCell *)cell
{
    [[AcquirerService sharedInstance].postbeService requestForPostbe:@"00000035"];
    
    SLBUserNotiDocViewController *userNotiViewCtrl = [[SLBUserNotiDocViewController alloc] init];
    userNotiViewCtrl.agreementType = SLBUserNotiTypeIntroduction;
    [self.navigationController pushViewController:userNotiViewCtrl animated:YES];
    [userNotiViewCtrl setNavigationTitle:@"生利宝常见问题"];
    [userNotiViewCtrl release];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return (1);
    }
    else if(section == 1) {
        return (2);
    }
    else {
        return (0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLBMenuAttributedCell *cell = [[[SLBMenuAttributedCell alloc] init] autorelease];
    
    NSMutableAttributedString *titleAttributed = nil;
    NSMutableAttributedString *textAttributed = nil;
    CTFontRef boldCTFont16 = [UIFont boldSystemFontOfSize:16].ctFont;
    CTFontRef CTFont15 = [UIFont systemFontOfSize:15].ctFont;
    CTFontRef CTFont12 = [UIFont systemFontOfSize:12].ctFont;
    CTFontRef CTFont10 = [UIFont systemFontOfSize:10].ctFont;
    switch(indexPath.section) {
            
        case 0: {
            cell.vxAlignment = alinmentToTop;
            
            switch(indexPath.row) {
                case 0: {
                    NSString *title = [NSMutableString stringWithString:@"可存入金额：\n"];
                    NSString *detailTitle = @"您当前POS刷卡待结算金额";
                    
                    titleAttributed = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:detailTitle]];
                    [titleAttributed beginEditing];
                    [titleAttributed addAttribute:(id)kCTFontAttributeName value:(id)boldCTFont16 range:NSMakeRange(0, title.length)];
                    [titleAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont12 range:NSMakeRange(title.length, detailTitle.length)];
                    [titleAttributed addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor lightGrayColor].CGColor range:NSMakeRange(title.length, detailTitle.length)];
                    [titleAttributed endEditing];
                    
                    NSString *totalAmountStr = [NSString micrometerSymbolAmount:_settleFund];
                    textAttributed = [[NSMutableAttributedString alloc] initWithString:[totalAmountStr stringByAppendingString:@"元"]];
                    [textAttributed beginEditing];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)boldCTFont16 range:NSMakeRange(0, totalAmountStr.length)];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont10 range:NSMakeRange(totalAmountStr.length, 1)];
                    [textAttributed addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor slbRedColor].CGColor range:NSMakeRange(0, totalAmountStr.length)];
                    [textAttributed endEditing];
                }break;
                    
                default:
                    break;
            }
        }break;
            
        case 1: {
            cell.vxAlignment = alinmentToCenter;
            
            switch(indexPath.row) {
                case 0: {
                    titleAttributed = [[NSMutableAttributedString alloc] initWithString:@"生利宝总金额："];
                    [titleAttributed beginEditing];
                    [titleAttributed addAttribute:(id)kCTFontAttributeName value:(id)boldCTFont16 range:NSMakeRange(0, titleAttributed.length)];
                    [titleAttributed endEditing];
                    
                    NSString *slbTotalAmountStr = [NSString micrometerSymbolAmount:_totalAsset];
                    textAttributed = [[NSMutableAttributedString alloc] initWithString:[slbTotalAmountStr stringByAppendingString:@"元"]];
                    [textAttributed beginEditing];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont15 range:NSMakeRange(0, slbTotalAmountStr.length)];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont10 range:NSMakeRange(slbTotalAmountStr.length, 1)];
                    [textAttributed endEditing];
                }break;
                    
                case 1: {
                    titleAttributed = [[NSMutableAttributedString alloc] initWithString:@"历史累计收益："];
                    [titleAttributed beginEditing];
                    [titleAttributed addAttribute:(id)kCTFontAttributeName value:(id)boldCTFont16 range:NSMakeRange(0, titleAttributed.length)];
                    [titleAttributed endEditing];
                    
                    NSString *totalAlearningsStr = [NSString micrometerSymbolAmount:_totalProfit];
                    textAttributed = [[NSMutableAttributedString alloc] initWithString:[totalAlearningsStr stringByAppendingString:@"元"]];
                    [textAttributed beginEditing];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont15 range:NSMakeRange(0, totalAlearningsStr.length)];
                    [textAttributed addAttribute:(id)kCTFontAttributeName value:(id)CTFont10 range:NSMakeRange(totalAlearningsStr.length, 1)];
                    [textAttributed endEditing];
                }break;
                    
                default:
                    break;
            }
        }break;
            
        default:
            break;
    }
    
    CFRelease(boldCTFont16);
    CFRelease(CTFont15);
    CFRelease(CTFont12);
    CFRelease(CTFont10);
    
    [cell setAttributedTitle:titleAttributed];
    [titleAttributed release];
    
    [cell setAttributedText:textAttributed];
    [textAttributed release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return (cell);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return (64.0f);
    }
    return (DEFAULT_ROW_HEIGHT);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
