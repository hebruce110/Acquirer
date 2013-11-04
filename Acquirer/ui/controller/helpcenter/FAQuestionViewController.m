//
//  FAQuestionViewController.m
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "FAQuestionViewController.h"
#import "NSNotificationCenter+CP.h"
#import "GeneralTableView.h"
#import "PlainCellContent.h"
#import "FAQuestionAnswerViewController.h"

@implementation FAQModel

@synthesize questionSTR, answerSTR;
@synthesize faqType;

-(void)dealloc{
    [questionSTR release];
    [answerSTR release];
    [super dealloc];
}

@end


@implementation FAQuestionViewController

@synthesize faqType, faqTV;

-(void)dealloc{
    [faqList release];
    
    [faqTV release];
    [faqTVList release];
    
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
        faqList = [[NSMutableArray alloc] init];
        faqTVList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)parseFAQConfiguration{
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"faq" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    if (![Helper stringNullOrEmpty:content]) {
        [faqList removeAllObjects];
        
        NSArray *lines = [content componentsSeparatedByString:@"\n"];
        for (NSString *line in lines) {
            if ([Helper stringNullOrEmpty:line]) {
                continue;
            }
            
            FAQModel *faqModel = [[FAQModel new] autorelease];
            
            //类型
            NSCharacterSet *splitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"＃#"];
            NSRange typeRange = [line rangeOfCharacterFromSet:splitCharSet];
            NSString *typeSTR = [line substringWithRange:NSMakeRange(0, typeRange.location)];
            if ([typeSTR isEqualToString:@"1"]) {
                faqModel.faqType = FaqTypeTrade;
            }else if ([typeSTR isEqualToString:@"2"]){
                faqModel.faqType = FaqTypeSettle;
            }
            
            //问题
            line = [line substringFromIndex:typeRange.location+1];
            NSRange questionRange = [line rangeOfCharacterFromSet:splitCharSet];
            NSString *questionSTR = [line substringWithRange:NSMakeRange(0, questionRange.location)];
            faqModel.questionSTR = questionSTR;
            
            //描述文字
            NSString *answerSTR = [line substringFromIndex:questionRange.location+1];
            faqModel.answerSTR = answerSTR;
            
            [faqList addObject:faqModel];
        }
        
    }else{
        [[NSNotificationCenter defaultCenter] postAutoTitaniumProtoNotification:@"faq.txt文件解析错误，请联系客服"
                                                                     notifyType:NOTIFICATION_TYPE_ERROR];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self parseFAQConfiguration];
    
    if (faqType == FaqTypeTrade) {
        [self setNavigationTitle:@"交易类常见问题"];
    }else if (faqType == FaqTypeSettle){
        [self setNavigationTitle:@"结算类常见问题"];
    }
    
    CGFloat contentWidth = self.contentView.bounds.size.width;
    CGFloat contentHeight = self.contentView.bounds.size.height;
    
    [faqTVList removeAllObjects];
    NSMutableArray *secOne = [[[NSMutableArray alloc] init] autorelease];
    for (FAQModel *faqModel in faqList) {
        if (faqModel.faqType == faqType) {
            [faqTVList addObject:faqModel];
            
            PlainCellContent *pc = [[PlainCellContent new] autorelease];
            pc.titleSTR = faqModel.questionSTR;
            pc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            pc.cellStyle = Cell_Style_Title_LineBreak;
            [secOne addObject:pc];
        }
    }
    
    self.faqTV = [[[GeneralTableView alloc] initWithFrame:CGRectMake(0, 10, contentWidth, contentHeight)
                                                    style:UITableViewStyleGrouped] autorelease];
    [faqTV setDelegateViewController:self];
    [faqTV setGeneralTableDataSource:[NSMutableArray arrayWithObject:secOne]];
    [self.contentView addSubview:faqTV];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FAQModel *faqModel = [faqTVList objectAtIndex:indexPath.row];
    
    FAQuestionAnswerViewController *faqCTRL = [[[FAQuestionAnswerViewController alloc] init] autorelease];
    faqCTRL.faqModel = faqModel;
    [self.navigationController pushViewController:faqCTRL animated:YES];
}


@end
