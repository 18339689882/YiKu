//
//  AppDelegate.h
//  ArtPage实战版
//
//  Created by Sunweisheng on 2018/9/26.
//  Copyright © 2018年 Sunweisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) UIBackgroundTaskIdentifier bgTask;

@property (nonatomic,strong) UINavigationController *navigation;

@end

