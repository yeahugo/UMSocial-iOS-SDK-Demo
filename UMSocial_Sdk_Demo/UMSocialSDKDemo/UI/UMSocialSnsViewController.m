//
//  UMSocialSnsViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-5-19.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsViewController.h"

#import "AppDelegate.h"
#import "UMSocial.h"
#import "WXApiObject.h"

@interface UMSocialSnsViewController ()

@end

@implementation UMSocialSnsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置黑色主题
//        [UMSocialConfig setTheme:UMSocialThemeBlack];
    }
    return self;
}


//下面可以设置根据点击不同的分享平台，设置不同的分享文字
/*
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToSina]) {
        socialData.shareText = @"分享到新浪微博";
    }
    else{
        socialData.shareText = @"分享内嵌文字";
    }
}
*/

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/*
 注意分享到新浪微博我们使用新浪微博SSO授权，你需要在xcode工程设置url scheme，并重写AppDelegate中的`- (BOOL)application openURL sourceApplication`方法，详细见文档。否则不能跳转回来原来的app。
 */
-(IBAction)showShareList1:(id)sender
{    
    //设置微信图文分享你可以用下面两种方法
    //1.用微信分享应用类型，用户分享给好友，对方点击跳转到手机应用或者打开url页面。需要另外设置应用下载地址，否则点击朋友圈进入友盟主页
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.appUrl = @"https://www.umeng.com";//设置你应用的下载地址
    
    //2.用微信web类型，用户点击直接打开web
    
//     [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeOther;
//     WXWebpageObject *webObject = [WXWebpageObject object];
//     webObject.webpageUrl = @"https://www.umeng.com"; //设置你自己的url地址
//     [UMSocialData defaultData].extConfig.wxMediaObject = webObject;
    
    
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
        
    //如果得到分享完成回调，可以设置delegate
    [UMSocialSnsService presentSnsIconSheetView:self appKey:useAppkey shareText:shareText shareImage:shareImage shareToSnsNames:nil delegate:self];
}

/*
 自定义分享样式，可以自己构造分享列表页面
 
 */
-(IBAction)showShareList3:(id)sender
{
    NSLog(@"allSnsValues is %@",[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray);
    
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        [editActionSheet addButtonWithTitle:snsPlatform.displayName];
    }
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    [editActionSheet showFromTabBar:self.tabBarController.tabBar];
    editActionSheet.delegate = self;
}


/*
 在自定义分享样式中，根据点击不同的点击来处理不同的的动作
 
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    
    //分享内嵌文字
    [UMSocialData defaultData].shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。";
    //分享内嵌图片
    [UMSocialData defaultData].shareImage = [UIImage imageNamed:@"UMS_social_demo"];
    
     //分享编辑页面的接口,snsName可以换成你想要的任意平台，例如UMShareToSina,UMShareToWechatTimeline
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (void)viewDidLoad
{    
    _shareButton1.center = CGPointMake(self.tabBarController.view.bounds.size.width/2, _shareButton1.center.y);
     _shareButton3.center = CGPointMake(self.tabBarController.view.bounds.size.width/2, _shareButton3.center.y);
    
    [super viewDidLoad];
    self.title = @"分享";
    self.tabBarItem.image = [UIImage imageNamed:@"UMS_share"];
    
     // Do any additional setup after loading the view from its nib.
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    /*
     如果要弹出的分享列表支持不同方向，需要在这里设置一下重新布局
     如果当前UIViewController有UINavigationController,则用self.navigationController.view，否则用self.view
     */
    UIView *iconActionSheet = [self.tabBarController.view viewWithTag:kTagSocialIconActionSheet];
    [iconActionSheet setNeedsDisplay];
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _shareButton1.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/5);
    _shareButton3.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/5 *3);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
