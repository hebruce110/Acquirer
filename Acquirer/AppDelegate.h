//
//  AppDelegate.h
//  Acquirer
//
//  Created by chinaPnr on 13-8-26.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VersionService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    VersionService *vs;
}

@property (strong, nonatomic) UIWindow *window;

@end
