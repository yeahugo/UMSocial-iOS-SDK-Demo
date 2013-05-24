//
//  UMSocialSnsViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-5-19.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsViewController.h"

#import "AppDelegate.h"
#import "UMSocialAFHTTPClient.h"
#import "UMImageView.h"
#import "UMUtils.h"

#import "UMSocial.h"
#import "WXApiObject.h"

@interface UMSocialSnsViewController ()

@end

@implementation UMSocialSnsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
        // Custom initialization
    }
    return self;
}

-(IBAction)showShareList1:(id)sender
{
    //这里设置微信图文分享,需要另外设置应用下载地址，否则点击朋友圈进入友盟主页
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialData defaultData].extConfig.appUrl = @"http://www.umeng.com";
    
    NSString *shareText = [UMSocialData defaultData].shareText;      //分享内嵌文字
    UIImage *image = [UMSocialData defaultData].shareImage;          //分享内嵌图片
    [UMSocialSnsService presentSnsIconSheetView:self appKey:useAppkey shareText:shareText shareImage:image shareToSnsNames:nil delegate:nil];
    
    /*
     //你也可以用下面的写法
     
     [UMSocialData defaultData].shareText = @"分享内嵌文字";
     [UMSocialData defaultData].shareImage =  [UIImage imageNamed:@"icon.png"];
     UMSocialIconActionSheet *iconActionSheet = [[UMSocialControllerService defaultControllerService] getSocialIconActionSheetInController:self];
     [iconActionSheet showInView:self.view];
     */
}

-(IBAction)showShareList2:(id)sender
{
    NSString *shareText = [UMSocialData defaultData].shareText;
    UIImage *image = [UMSocialData defaultData].shareImage;
    [UMSocialSnsService presentSnsController:self appKey:useAppkey shareText:shareText shareImage:image shareToSnsNames:nil delegate:nil];

    /*
     //你也可以用下面的写法
     [UMSocialData defaultData].shareText = @"分享内嵌文字";
     [UMSocialData defaultData].shareImage =  [UIImage imageNamed:@"icon.png"];
     UINavigationController *navigationController = [[UMSocialControllerService defaultControllerService] getSocialShareListController];
     [self presentModalViewController:navigationController animated:YES];

     */
}


/*
 自定义分享样式，可以自己构造分享列表页面
 
 */
-(IBAction)showShareList3:(id)sender
{
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
    
    /*
    //你可以这样根据不同的平台指定不同的内容
    if (buttonIndex == 1) {
        [UMSocialData defaultData].shareText = @"分享文字";
    }
     */
    //分享编辑页面的接口
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (void)viewDidLoad
{
//    [UMSocialData defaultData].shareText = @"友盟社会化分享 http://www.umeng.com/";
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 170);
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    UMSocialAFHTTPClient *httpClient = [UMSocialAFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://blog.umeng.com/"]];
    [httpClient getPath:@"/api/get_recent_posts/" parameters:nil success:^(UMSocialAFHTTPRequestOperation *operation, id responseObject){
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [UMUtils JSONValue:jsonString];

        [_activityIndicatorView stopAnimating];
        
        NSDictionary *postsDic = [[NSDictionary alloc] initWithDictionary:[[jsonDic valueForKey:@"posts"] objectAtIndex:0]];
        self.postsDic = postsDic;

        [[NSUserDefaults standardUserDefaults] setValue:self.postsDic forKey:@"posts"];
        
        NSString *title = [self.postsDic  valueForKey:@"title"];
        NSString *url = [self.postsDic  valueForKey:@"url"];
        NSString *shareText = [NSString stringWithFormat:@"%@  %@",title,url];
        [UMSocialData defaultData].shareText = shareText;
        if ([[self.postsDic valueForKey:@"attachments"] count] > 0) {
            NSString *imageUrl = [[[self.postsDic valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"url"];
            UMImageView *imageView = [[UMImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"yinxing0"]];
            imageView.imageURL = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [UMSocialData defaultData].shareImage = imageView.image;
        }
        
    } failure:^(UMSocialAFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error is %@ %d",error,error.code);
        if (error.code == -1009) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"获取数据失败" message:@"当前设备的网络状态不正常，请稍后重试" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
        else{
            NSLog(@"connect to the umeng blog server fail!!");
        }
        [_activityIndicatorView stopAnimating];
    }];
    [super viewDidLoad];
    self.title = @"分享";
    self.tabBarItem.image = [UIImage imageNamed:@"UMS_share"];
    // Do any additional setup after loading the view from its nib.
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
