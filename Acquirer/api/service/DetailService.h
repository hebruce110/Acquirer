//
//  DetailService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-24.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

typedef enum _DetailType{
    Detail_Type_History = 0,
    Detail_Type_Today,
} DetailType;

typedef enum _ReqFlag{
    Req_Flag_All = 1,
    Req_Flag_Success,
    Req_Flag_Failure
} ReqFlag;

@interface DetailService : BaseService{
}

/*
 detailType：今日｜历史
 resendFlag：分页上次接收的resend值
 reqflag：请求的类型：全部｜成功｜失败
 cardNoSTR：银行卡号
 amtSTR：交易金额
 */
-(void)requestForTradeDetail:(DetailType) detailType withResendFlag:(NSString *)resendFlag withReqFlag:(ReqFlag)flag
                  withCardNo:(NSString *) cardNoSTR withAmt:(NSString *) amtSTR
                    fromDate:(NSString *) fdate toDate:(NSString *) tdate;

-(void)requestForTradeDetailInfo:(NSString *)orderId;

@end
