//
//  AppDelegate.m
//  UMSocialSDKDemo
//
//  Created by yeahugo on 12-9-18.
//  Copyright (c) 2012年 yeahugo. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialTabBarController.h"
#import "UMSocialData.h"
#import "WXApi.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [UMSocialData setAppKey:useAppkey];
    UMSocialTabBarController *tabViewController = [[UMSocialTabBarController alloc] init];
    self.window.rootViewController = tabViewController;
    [UMSocialData openLog:YES];
    //向微信注册
    [WXApi registerApp:@"wxd9a39c7122aa6516"];
    
    return YES;
}


-(void) onReq:(BaseReq*)req
{
    NSLog(@"req type is %d",req.type);
}


-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req type is %d",resp.type);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString * message = nil;
        message = [NSString stringWithFormat:@"%d",resp.errCode];
        if (resp.errCode == WXSuccess) {
            message = @"成功";
        }
//        else if (resp.errCode == WXErrCodeCommon) {
//            message = @"其他";
//        }
//        else if (resp.errCode == WXErrCodeUserCancel) {
//            message = @"用户取消";
//        }
        else if (resp.errCode == WXErrCodeSentFail) {
            message = @"发送失败";
        }
        else if (resp.errCode == WXErrCodeAuthDeny)
        {
            message = @"授权失败";
        }
        else if (resp.errCode == WXErrCodeUnsupport){
            message = @"不支持";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享结果" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
