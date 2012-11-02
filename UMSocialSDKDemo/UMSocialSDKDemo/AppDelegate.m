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

//- (NSArray *)shareToPlatforms
//{
//    NSNumber *sinaNumber = [NSNumber numberWithInt:UMSocialSnsTypeSina];
//    NSArray *shareToArray = [NSArray arrayWithObjects:sinaNumber, nil];
//    return shareToArray;
//}

#pragma mark - UMSocialConfigDelegate

-(UITableViewCell *)customCellForShareListTableView
{
    UITableViewCell *weiXinCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weixinCell"] ;
    weiXinCell.textLabel.text = @"微信分享";
    weiXinCell.imageView.image = [UIImage imageNamed:@"weixin_icon"];
    return weiXinCell;
}

-(void)didSelectShareListTableViewCell
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = @"test";
        req.scene = WXSceneSession;
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
        
        [WXApi sendReq:req];
    }
    NSLog(@"分享到微信");
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
