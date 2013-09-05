//
//  PosMiniSettings.m
//  Acquirer
//
//  Created by chinaPnr on 13-7-10.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "Settings.h"

@interface Settings()
@property (nonatomic, retain) NSMutableDictionary* settingsDict;
@end


static Settings* sInstance = nil;

@implementation Settings

@synthesize settingsDict = mSettingsDict;
@synthesize isAbsolutePath;

-(void)dealloc{
    self.settingsDict = nil;
    [super dealloc];
}

+(Settings*) sharedInstance {
    if(sInstance == nil)
    {
        sInstance = [Settings new];
    }
    return sInstance;
}

+(void)destroySharedInstance{
    CPSafeRelease(sInstance);
}

-(id)init{
    if((self = [super init])){
        self.settingsDict = [NSMutableDictionary dictionaryWithCapacity:20];
        
		[self setDefaultTag:@"server-url" value:HOST_URL];
        
        isAbsolutePath = NO;
    }
    return self;
}

-(NSString*)getSetting:(NSString*) key{
    return [self.settingsDict objectForKey:key];
}

-(void) setDefaultTag:(NSString*)tag value:(NSString*)value{
    [self.settingsDict setObject:value forKey:tag];
}

@end
