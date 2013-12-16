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

//检查版本更新，并记录当前版本
-(void)requestForVersionCheck;

//应用内检查版本更新
-(void)requestForInAppVersionCheck;

//Postbe记录用户行为
-(void)requestForPostbe:(NSString *)functionId;

@end
