//
//  EncashRes.h
//  Acquirer
//
//  Created by peer on 11/6/13.
//  Copyright (c) 2013 chinaPnr. All rights reserved.
//

#ifndef Acquirer_EncashRes_h
#define Acquirer_EncashRes_h

typedef enum _EncashRes{
    //取现成功
    EncashSuccess = 0,
    //取现失败
    EncashFailure,
    //处理中
    EncashPending
} EncashRes;

#endif
