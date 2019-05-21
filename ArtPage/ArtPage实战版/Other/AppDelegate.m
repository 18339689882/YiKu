//
//  AppDelegate.m
//  ArtPage实战版
//
//  Created by Sunweisheng on 2018/9/26.
//  Copyright © 2018年 Sunweisheng. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

#import "LoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *Vc = [[LoginViewController alloc] init];
    _navigation = [[UINavigationController alloc] initWithRootViewController:Vc];
    self.window.rootViewController = _navigation;
    [self.window makeKeyAndVisible];
    
    //向微信注册，这句必需要有才能在具体的地方实现分享功能。
    [WXApi registerApp:@"wx4868b35061f87885"];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //后台下载。
    __weak typeof(self) weakSelf = self;
    UIApplication *app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [app endBackgroundTask:self.bgTask];
            weakSelf.bgTask = UIBackgroundTaskInvalid;
        });
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp
{
    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
    //使用UIAlertView 显示回调信息
    NSString *str = [NSString stringWithFormat:@"%d",sendResp.errCode];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"回调信息" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alertview show];
}

@end
