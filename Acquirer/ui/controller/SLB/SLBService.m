//
//  SLBService.m
//  Acquirer
//
//  Created by Soal on 13-10-27.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "SLBService.h"
#import "ASIHTTPRequest.h"

static SLBService *service = nil;

@implementation SLBService

@synthesize slbUser = _slbUser;

+ (SLBService *)sharedService
{
    @synchronized([self class])
    {
        if(service == nil)
        {
            service = [[SLBService alloc] init];
        }
    }
    return (service);
}

- (void)dealloc
{
    [_slbUser release];
    _slbUser = nil;
    
    [_querySer release];
    _querySer = nil;
    
    [_openSer release];
    _openSer = nil;
    
    [_changeAmountSer release];
    _changeAmountSer = nil;
    
    [_detailListSer release];
    _detailListSer = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self) {
        _slbUser = [[SLBUser alloc] init];
        
        _querySer = [[SLBQueryService alloc] init];
        _openSer = [[SLBOpenService alloc] init];
        _changeAmountSer = [[SLBChangeAmountService alloc] init];
        _detailListSer = [[SLBDetailListService alloc] init];
    }
    return (self);
}

@end

