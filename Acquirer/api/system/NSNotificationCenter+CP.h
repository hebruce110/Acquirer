//
//  CPRequest.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-9.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (CP)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

-(void)postAutoSysPromptNotification:(NSString *)message;
-(void)postAutoUIPromptNotification:(NSString *)message;

-(void)postAutoTitaniumProtoNotification:(NSString *)message notifyType:(NSString *)typeString;

@end

