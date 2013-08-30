//
//  PosMiniSettings.h
//  Acquirer
//
//  Created by chinaPnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject{
@private
    NSMutableDictionary *mSettingsDict;
    BOOL isAbsolutePath;
}

@property (nonatomic, assign) BOOL isAbsolutePath;

+(Settings*) sharedInstance;
+(void)destroyInstance;

-(NSString*)getSetting:(NSString*) key;
-(void) setDefaultTag:(NSString*)tag value:(NSString*)value;

@end
