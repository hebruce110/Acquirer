//
//  SLBUserNotiDocViewController.m
//  Acquirer
//
//  Created by SoalHuang on 13-10-25.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBUserNotiDocViewController.h"
#import "CTView.h"
#import "MarkupParser.h"
#import "SafeObject.h"

@interface SLBUserNotiDocViewController ()

@property (retain, nonatomic) CTView *ctVw;
@property (retain, nonatomic) UITextView *txView;

@end

@implementation SLBUserNotiDocViewController

- (void)dealloc
{
    self.ctVw = nil;
    self.txView = nil;
    
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
        
        _agreementType = SLBUserNotiTypeAuthorization;
        _ctVw = nil;
        _txView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat space = 10.0f;
    CGRect ctBounds = self.contentView.bounds;
    _ctVw = [[CTView alloc] init];
    _ctVw.frame = CGRectMake(space, 0, ctBounds.size.width - space, ctBounds.size.height);
    _ctVw.contentInset = UIEdgeInsetsMake(space, 0, space, 0);
    _ctVw.contentSize = CGSizeMake(ctBounds.size.width - space * 2.0f, ctBounds.size.height);
    
    [self.contentView addSubview:_ctVw];
    _txView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 0, ctBounds.size.width - 6.0f, ctBounds.size.height)];
    _txView.contentInset = _ctVw.contentInset;
    _txView.editable = NO;
    _txView.backgroundColor = [UIColor clearColor];
    _txView.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_txView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *fileName = nil;
    switch(_agreementType) {
        case SLBUserNotiTypeAuthorization: {
            fileName = @"slbAuthorization";
            [_ctVw removeFromSuperview];
        }break;
            
        case SLBUserNotiTypeServe: {
            fileName = @"slbServe";
            [_txView removeFromSuperview];
        }break;
            
        case SLBUserNotiTypeIntroduction: {
            fileName = @"slbIntroduction";
            [_ctVw removeFromSuperview];
        }break;
            
        default:
        break;
    }
    
    if(fileName && fileName.length > 0) {
        
        [[Acquirer sharedInstance] showUIPromptMessage:@"加载中..." animated:YES];
        
        __block CTView *blCTView = _ctVw;
        __block UITextView *blTxView = _txView;
        __block NSString *blFileName = fileName;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *path = [[NSBundle mainBundle] pathForResource:blFileName ofType:@"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            NSString* text = [dict stringObjectForKey:@"text"];
            MarkupParser* parser = [[[MarkupParser alloc] init] autorelease];
            NSAttributedString* attString = [parser attrStringFromMarkup:text];
            
            if(_agreementType == SLBUserNotiTypeServe) {
                [blCTView setAttString:attString withImages: parser.images];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                [[Acquirer sharedInstance] hideUIPromptMessage:YES];
                if(_agreementType == SLBUserNotiTypeServe) {
                    [blCTView buildFrames];
                }
                else {
                    [blTxView setText:text];
                }
            });
        });
    }
}

@end
