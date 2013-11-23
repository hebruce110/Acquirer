//
//  NoticeAddViewController.m
//  Acquirer
//
//  Created by Soal on 13-11-4.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "NoticeAddViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NoticeViewController.h"

static NSInteger titleMaxLength = 18;
static NSInteger textMaxLength = 150;

@interface NoticeAddViewController () <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIScrollView *scrView;

@property (retain, nonatomic) UITextField *titleTextField;
@property (retain, nonatomic) UITextView *textView;
@property (retain, nonatomic) UIButton *submitButton;

@end

@implementation NoticeAddViewController

- (void)dealloc
{    
    [_scrView release];
    _scrView = nil;
    
    [_titleTextField release];
    _titleTextField = nil;
    
    [_textView release];
    _textView = nil;
    
    [_submitButton release];
    _submitButton = nil;
    
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
        _scrView = nil;
        _titleTextField = nil;
        _textView= nil;
        _submitButton = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"添加新留言"];
    
    [self setUpSubViews];
    
    [self checkSubmitButtonState];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
    tapGesture.delegate = self;
    [self.contentView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)setUpSubViews
{
    _scrView = [[UIScrollView alloc] init];
    _scrView.frame = self.contentView.bounds;
    _scrView.contentSize = self.contentView.bounds.size;
    _scrView.scrollEnabled = YES;
    _scrView.pagingEnabled = NO;
    
    CGFloat space = 15.0f;
    CGFloat width = self.contentView.bounds.size.width - space * 2.0f;
    
    UILabel *tlLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 50.0f)];
    tlLb.backgroundColor = [UIColor clearColor];
    tlLb.textColor = [UIColor grayColor];
    tlLb.textAlignment = NSTextAlignmentCenter;
    tlLb.font = [UIFont boldSystemFontOfSize:13];
    tlLb.text = @"请在此输入您对我们的建议，我们将认真倾听：";
    [_scrView addSubview:tlLb];
    [tlLb release];
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(tlLb.frame), width, 40)];
    _titleTextField.borderStyle = UITextBorderStyleRoundedRect;
    _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleTextField.font = [UIFont systemFontOfSize:14];
    _titleTextField.delegate = self;
    _titleTextField.placeholder = @"请输入标题（必填）";
    [_scrView addSubview:_titleTextField];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(_titleTextField.frame) + space, width, 180.0f)];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.cornerRadius = 6.0f;
    _textView.clipsToBounds = YES;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.delegate = self;
    [_scrView addSubview:_textView];
    
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 57.0f)];
    _submitButton.center = CGPointMake(_scrView.bounds.size.width / 2.0f, _scrView.bounds.size.height - space - _submitButton.bounds.size.height / 2.0f);
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_off"] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateHighlighted];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"BUTT_red_on"] forState:UIControlStateSelected];
    _submitButton.layer.cornerRadius = 5.0f;
    _submitButton.clipsToBounds = YES;
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_scrView addSubview:_submitButton];
    
    [self.contentView addSubview:_scrView];
}

- (void)submitButtonTouched:(id)sender
{
    NSString *title = _titleTextField.text;
    NSString *text = _textView.text;
    [self addLeaveMessageTitle:title text:text];
}

- (void)hideKeyborad
{
    [self.view endEditing:YES];
}

- (void)checkSubmitButtonState
{
    if(_titleTextField.text && _titleTextField.text.length > 0 && _textView.text && _textView.text.length > 0)
    {
        _submitButton.enabled = YES;
    }
    else
    {
        _submitButton.enabled = NO;
    }
    
    if(_textView.text && _textView.text.length > 0)
    {
        [self hideTextViewPlaceholder];
    }
    else
    {
        [self showTextViewPlaceholder];
    }
}

static NSInteger txVwHolderTag = 1000;
- (void)showTextViewPlaceholder
{
    UILabel *holderLabel = (UILabel *)[_textView viewWithTag:txVwHolderTag];
    if(!holderLabel)
    {
        CGFloat space = 8.0f;
        holderLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, _textView.bounds.size.width - space * 2.0f, 34)];
        holderLabel.tag = txVwHolderTag;
        holderLabel.backgroundColor = [UIColor clearColor];
        holderLabel.textColor = [UIColor lightGrayColor];
        holderLabel.text = [NSString stringWithFormat:@"请将留言字数控制在%i字以内", textMaxLength];
        holderLabel.font = _textView.font;
        [_textView addSubview:holderLabel];
        [holderLabel release];
    }
}

- (void)hideTextViewPlaceholder
{
    UILabel *holderLabel = (UILabel *)[_textView viewWithTag:txVwHolderTag];
    if(holderLabel)
    {
        [holderLabel removeFromSuperview];
    }
}

#pragma mark - network
- (void)addLeaveMessageTitle:(NSString *)title text:(NSString *)text
{
    NoticeService *noticeService = [AcquirerService sharedInstance].noticeService;
    [noticeService requestAddLeaveMessageByTitle:title content:text Taget:self action:@selector(addLeaveMessageDidFinished:)];
}

- (void)addLeaveMessageDidFinished:(AcquirerCPRequest *)request
{
    NSDictionary *body = (NSDictionary *)request.responseAsJson;
    if(NotNilAndEqualsTo(body, @"isSucc", @"1"))
    {
        //新增成功
        
        @autoreleasepool {
            [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"提交成功，感谢您的宝贵意见" notifyType:NOTIFICATION_TYPE_SUCCESS];
        }
        _titleTextField.text = nil;
        _textView.text = nil;
        [self checkSubmitButtonState];
        
        for(id ctrl in self.navigationController.viewControllers)
        {
            if([ctrl isKindOfClass:[NoticeViewController class]])
            {
                NoticeViewController *notiCtrl = (NoticeViewController *)ctrl;
                notiCtrl.isNeedRefresh = YES;
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = [touch view];
    if([touchView isKindOfClass:[UIControl class]])
    {
        return (NO);
    }
    return (YES);
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0 animations:^(void){
        CGRect fm = _scrView.frame;
        fm.size.height = self.contentView.bounds.size.height - (216.0f - 20.0f);
        _scrView.frame = fm;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0 animations:^(void){
        CGRect fm = _scrView.frame;
        fm.size.height = self.contentView.bounds.size.height;
        _scrView.frame = fm;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(checkSubmitButtonState) withObject:nil afterDelay:0.1f];
    
    if(range.location + string.length <= titleMaxLength)
    {
        return (YES);
    }
    return (NO);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0 animations:^(void){
        CGRect fm = _scrView.frame;
        fm.size.height = self.contentView.bounds.size.height - (216.0f - 20.0f);
        _scrView.frame = fm;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0 animations:^(void){
        CGRect fm = _scrView.frame;
        fm.size.height = self.contentView.bounds.size.height;
        _scrView.frame = fm;
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self performSelector:@selector(checkSubmitButtonState) withObject:nil afterDelay:0.01f];
    
    if(range.location + text.length <= textMaxLength)
    {
        return (YES);
    }
    return (NO);
}

@end

