//
//  AppDelegate.m
//  hello-weex-ios
//
//  Created by wenguang pan on 2017/10/23.
//  Copyright © 2017年 wenguang pan. All rights reserved.
//

#import "AppDelegate.h"

#import <WeexSDK/WeexSDK.h>
#ifdef DEBUG
#import <TBWXDevTool/WXDevTool.h>
#endif

#import "WeexViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
#ifdef DEBUG
    //use weex-devtool to start debug server and paste debug url here
    //[WXDevTool launchDevToolDebugWithUrl:@"ws://127.0.0.1:8088/debugProxy/native"];
#endif
    [WXAppConfiguration setAppName:@"hello-weex-ios"];
    [WXSDKEngine initSDKEnvironment];
    
    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"]];
    UIViewController *vc = [[WeexViewController alloc] initWithSourceURL:url];
    self.window.rootViewController = vc;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


@end
