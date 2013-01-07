//
//  AppDelegate.m
//  UMSocialSDKDemo
//
//  Created by yeahugo on 12-9-18.
//  Copyright (c) 2012年 yeahugo. All rights reserved.
//

#import "AppDelegate.h"
#import "UMSocialDemoTableController.h"
#import "UMSocialData.h"
#import "WXApi.h"

#define umeng_appkey @"507fcab25270157b37000010"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:umeng_appkey];
    UMSocialDemoTableController *demoViewController = [[UMSocialDemoTableController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:demoViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.rootViewController= navigationController;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [UMSocialData openLog:YES];
    //向微信注册
    [WXApi registerApp:@"wxd9a39c7122aa6516"];
    [UMSocialControllerService setSocialConfigDelegate:self];
    return YES;
}

//设置Social SDK所支持的屏幕方向，返回的是ios6 定义的UIInterfaceOrientationMask
/*
- (NSUInteger)supportedInterfaceOrientationsForUMSocialSDK
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    return UIInterfaceOrientationMaskPortrait;
#else
    return 1 << UIInterfaceOrientationPortrait;
#endif
}
*/

//设置官方微博，只支持新浪微博和腾讯微博
-(NSDictionary *)followSnsUids
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1920318374",UMShareToSina,nil];
    return dictionary;
}

//设置出现的sns平台
//- (NSArray *)shareToPlatforms
//{
//    NSArray *shareToArray = [NSArray arrayWithObjects:UMShareToSina,
//                             UMShareToTencent,
//                             UMShareToEmail,
//                             UMShareToSms,
//                             nil];
//    return shareToArray;
//}


#pragma mark - UMSocialConfigDelegate
-(UITableViewCell *)customCellForShareListTableView
{
    UITableViewCell *weiXinCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weixinCell"] ;
    weiXinCell.textLabel.text = @"微信分享";
    weiXinCell.imageView.image = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_weixin_icon.png"];
    return weiXinCell;
}

-(void)didSelectShareListTableViewCell:(UITableView *)tableView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到微信" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到会话",@"分享到朋友圈",nil];
    [actionSheet showInView:tableView];

    NSLog(@"分享到微信");
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"test";
        
        req.bText = YES;
        
        /*下面实现图片分享，只能分享文字或者分享图片，或者分享url，里面带有图片缩略图和描述文字
         WXMediaMessage * message = [WXMediaMessage message];
         WXImageObject *ext = [WXImageObject object];
         NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yinxing0" ofType:@"jpg"];
         ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
         
         message.mediaObject = ext;
         [message setThumbImage:[UIImage imageNamed:@"yinxing0"]];
         req.message = message;
         req.bText = NO;
         */
        
        if (buttonIndex == 0) {
            req.scene = WXSceneSession;
        }
        if (buttonIndex == 1) {
            req.scene = WXSceneTimeline;
        }
        [WXApi sendReq:req];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
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
        NSString *strTitle = [NSString stringWithFormat:@"微信发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"微信发送消息结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
