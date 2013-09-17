//
//  CodeCSVService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface CodeCSVService : BaseService{
    int codeVersion;
}

-(void)requestForCodeCSVVersion;
-(void)requestForDownloadCodeCSV;


@end
