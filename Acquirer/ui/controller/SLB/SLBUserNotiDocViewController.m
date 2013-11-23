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
    [_ctVw release];
    _ctVw = nil;
    
    [_txView release];
    _txView = nil;
    
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
    
    CGFloat space = 5.0f;
    CGRect ctBounds = self.contentView.bounds;
    _ctVw = [[CTView alloc] init];
    _ctVw.frame = CGRectMake(0, space, ctBounds.size.width, ctBounds.size.height - space * 2.0f);
    [self.contentView addSubview:_ctVw];
    
    _txView = [[UITextView alloc] initWithFrame:_ctVw.frame];
    _txView.editable = NO;
    _txView.backgroundColor = [UIColor clearColor];
    _txView.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_txView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *fileName = nil;
    switch(_agreementType)
    {
        case SLBUserNotiTypeAuthorization:
        {
            fileName = @"slbAuthorization";
            [_ctVw removeFromSuperview];
        }break;
            
        case SLBUserNotiTypeServe:
        {
            fileName = @"slbServe";
//            _ctVw.lastPageOffset = - 0.4f;
            if(IS_IPHONE5)
            {
//                _ctVw.lastPageOffset = - 0.15f;
            }
            [_txView removeFromSuperview];
        }break;
            
        case SLBUserNotiTypeIntroduction:
        {
            fileName = @"slbIntroduction";
            [_ctVw removeFromSuperview];
        }break;
            
        default:
        break;
    }
    
    if(fileName && fileName.length > 0)
    {
        [[Acquirer sharedInstance] showUIPromptMessage:@"加载中..." animated:YES];
        __block CTView *blCTView = _ctVw;
        __block UITextView *blTxView = _txView;
        __block NSString *blFileName = fileName;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSString *path = [[NSBundle mainBundle] pathForResource:blFileName ofType:@"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            NSString* text = [dict safeJsonObjForKey:@"text"];
            MarkupParser* parser = [[[MarkupParser alloc] init] autorelease];
            NSAttributedString* attString = [parser attrStringFromMarkup:text];
            
            if(_agreementType == SLBUserNotiTypeServe)
            {
                [blCTView setAttString:attString withImages: parser.images];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^(void){
                [[Acquirer sharedInstance] hideUIPromptMessage:YES];
                if(_agreementType == SLBUserNotiTypeServe)
                {
                    [blCTView buildFrames];
                }
                else
                {
                    [blTxView setText:text];
                }
            });
        });
    }
}

@end
