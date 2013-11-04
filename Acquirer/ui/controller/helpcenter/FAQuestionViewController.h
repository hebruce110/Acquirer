//
//  FAQuestionViewController.h
//  Acquirer
//
//  Created by peer on 11/4/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#import "BaseViewController.h"

typedef enum _FaqType{
    //交易类常见问题
    FaqTypeTrade = 0,
    //结算类常见问题
    FaqTypeSettle,
}FaqType;

@interface FAQModel : NSObject{
    NSString *questionSTR;
    NSString *answerSTR;
    FaqType faqType;
}

@property (nonatomic, copy) NSString *questionSTR;
@property (nonatomic, copy) NSString *answerSTR;
@property (nonatomic, assign) FaqType faqType;

@end

@class GeneralTableView;

@interface FAQuestionViewController : BaseViewController{
    NSMutableArray *faqList;
    FaqType faqType;
    
    GeneralTableView *faqTV;
    //tableview 数据源
    NSMutableArray *faqTVList;
}

@property (nonatomic, assign) FaqType faqType;
@property (nonatomic, retain) GeneralTableView *faqTV;

-(void)parseFAQConfiguration;

@end
