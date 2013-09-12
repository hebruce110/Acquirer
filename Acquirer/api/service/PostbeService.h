//
//  VersionService.h
//  Acquirer
//
//  Created by chinapnr on 13-9-3.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "BaseService.h"

@interface PostbeService : BaseService <UIAlertViewDelegate>

-(void)requestForUID;

-(void)requestForVersionCheck;

@end
