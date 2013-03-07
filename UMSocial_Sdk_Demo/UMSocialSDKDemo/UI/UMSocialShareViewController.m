//
//  UMSocialShareViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-22.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialShareViewController.h"
#import "UMStringMock.h"
#import "WXApi.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialSnsService.h"
#import "AppDelegate.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialIconActionSheet.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatform.h"

#import "UMSocialAFHTTPClient.h"
#import "UMUtils.h"

#import "UMSocialBarViewController.h"

#define kTagWithUMSnsAction 100

@interface UMSocialShareViewController ()

@end

@implementation UMSocialShareViewController

@synthesize postsArray = _postsArray;

-(void)dealloc
{
    SAFE_ARC_RELEASE(_socialController);
    SAFE_ARC_RELEASE(_postsArray);
    SAFE_ARC_RELEASE(_locationManager);
    SAFE_ARC_RELEASE(_activityIndicatorView);
    SAFE_ARC_RELEASE(_shareButton1);
    SAFE_ARC_RELEASE(_shareButton2);
    SAFE_ARC_RELEASE(_shareButton3);
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialSDK" withTitle:nil];
//  下面发送视频到微博，可以发送url的视频、音乐和图片
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:
                                        UMSocialUrlResourceTypeMusic url:@"http://www.xiami.com/song/2100097"];
    socialData.urlResource = urlResource;
    SAFE_ARC_RELEASE(urlResource);
    
    _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    _socialController.socialUIDelegate = self;
    SAFE_ARC_RELEASE(socialData); 

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.center = CGPointMake(160, 150);
    
    _locationManager = [[NSClassFromString(@"CLLocationManager") alloc] init];
    [_locationManager startUpdatingLocation];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - 110)];
    [self.view addSubview:_webView];
    
    _shareButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SAFE_ARC_RETAIN(_shareButton1);
    _shareButton1.frame = CGRectMake(0, size.height - 110, 100, 40);
    [_shareButton1 setTitle:@"分享列表1" forState:UIControlStateNormal];
    [_shareButton1 addTarget:self action:@selector(presentShareList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton1];
    
    _shareButton2 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    SAFE_ARC_RETAIN(_shareButton2);
    _shareButton2.frame = CGRectMake(110, size.height - 110, 100, 40);
    [_shareButton2 setTitle:@"分享列表2" forState:UIControlStateNormal];
    [_shareButton2 addTarget:self action:@selector(showSnsActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton2];
    
    _shareButton3 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    SAFE_ARC_RETAIN(_shareButton3);
    _shareButton3.frame = CGRectMake(220, size.height - 110, 100, 40);
    [_shareButton3 setTitle:@"分享列表3" forState:UIControlStateNormal];
    [_shareButton3 addTarget:self action:@selector(showSnsEditSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareButton3];
    
    [self.view addSubview:_activityIndicatorView];
    
    NSArray *postsArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"postsArray"];
    if (postsArray != nil) {
        self.postsArray = postsArray;
        [_webView loadHTMLString:[[self.postsArray objectAtIndex:0] valueForKey:@"content"] baseURL:nil];
        NSString *title = [[self.postsArray objectAtIndex:0] valueForKey:@"title"];
        NSString *url = [[self.postsArray objectAtIndex:0] valueForKey:@"url"];
        NSString *shareText = [NSString stringWithFormat:@"%@ %@",title,url];
        socialData.shareText = shareText;
    }
    else{
        socialData.shareText = [UMStringMock commentMockString];
    }
    
    UMSocialAFHTTPClient *httpClient = [UMSocialAFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://blog.umeng.com/"]];
    [httpClient getPath:@"/api/get_recent_posts/" parameters:nil success:^(UMSocialAFHTTPRequestOperation *operation, id responseObject){
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [UMUtils JSONValue:jsonString];
        SAFE_ARC_RELEASE(jsonString);
        [_activityIndicatorView stopAnimating];

        NSArray *postsArray = [[NSArray alloc] initWithArray:[jsonDic valueForKey:@"posts"]];
        self.postsArray = postsArray;
        SAFE_ARC_RELEASE(postsArray);
        [[NSUserDefaults standardUserDefaults] setValue:self.postsArray forKey:@"postsArray"];

        NSString *title = [[self.postsArray objectAtIndex:0] valueForKey:@"title"];
        NSString *url = [[self.postsArray objectAtIndex:0] valueForKey:@"url"];
        NSString *shareText = [NSString stringWithFormat:@"%@  %@",title,url];
        socialData.shareText = shareText;
        
        [_webView loadHTMLString:[[self.postsArray objectAtIndex:0] valueForKey:@"content"] baseURL:nil];
        
        if ([[[self.postsArray objectAtIndex:0] valueForKey:@"attachments"] count] > 0) {
            NSString *imageUrl = [[[[self.postsArray objectAtIndex:0] valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"url"];
            UMImageView *imageView = [[UMImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"yinxing0"]];
            imageView.imageURL = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            socialData.shareImage = imageView.image;
            SAFE_ARC_RELEASE(imageView);
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
}

-(void)presentShareList
{
    UINavigationController *shareNavigationController = [_socialController getSocialShareListController];
    [self presentModalViewController:shareNavigationController animated:YES];
}

-(void)showSnsActionSheet
{
    @try {
        UMSocialIconActionSheet *iconActionSheet = [_socialController getSocialIconActionSheetInController:self];
        iconActionSheet.tag = kTagWithUMSnsAction;

        [iconActionSheet showInView:self.view];
    }
    @catch (NSException *exception) {
        UMLog(@"you must set the snsName as a NSString not a NSNumber !");
    }
    @finally {
        
    }
}

-(void)showSnsEditSheet
{
    UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    editActionSheet.tag = UMShareEditPresent;
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        [editActionSheet addButtonWithTitle:snsPlatform.displayName];
    }
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    [editActionSheet showFromTabBar:self.tabBarController.tabBar];
    editActionSheet.delegate = self;
    SAFE_ARC_RELEASE(editActionSheet);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    
    //分享编辑页面的接口
    NSString *snaName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snaName];
    
    snsPlatform.snsClickHandler(self,_socialController,YES);
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"response is %@",response);
    UIAlertView *alertView;
    [_activityIndicatorView stopAnimating];
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (response.responseType == UMSResponseShareToSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是数据级的发送微博接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }
        if (response.responseType == UMSResponseShareToMutilSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是发送到多个微博平台的数据级接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }        
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"亲，您刚才调用的发送微博接口发送失败了，具体原因请看到回调方法response对象的responseCode和message~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
        SAFE_ARC_RELEASE(alertView);
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _webView.frame = CGRectMake(0, 0, self.tabBarController.view.bounds.size.height , self.tabBarController.view.bounds.size.width - 90);
    _shareButton1.frame = CGRectMake(_shareButton1.frame.origin.x, self.tabBarController.view.bounds.size.width - 110, _shareButton1.frame.size.width, 40);
    _shareButton2.frame = CGRectMake(_shareButton2.frame.origin.x, self.tabBarController.view.bounds.size.width - 110, _shareButton2.frame.size.width, 40);
    _shareButton3.frame = CGRectMake(_shareButton3.frame.origin.x, self.tabBarController.view.bounds.size.width - 110, _shareButton3.frame.size.width, 40);
    
    if ([self.view viewWithTag:kTagWithUMSnsAction]) {
        UMSocialIconActionSheet *socialIconActionSheet = (UMSocialIconActionSheet *)[self.view viewWithTag:kTagWithUMSnsAction];
        [socialIconActionSheet setNeedsDisplay];
    }
}

#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didCloseUIViewController with type is %d",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}

@end
