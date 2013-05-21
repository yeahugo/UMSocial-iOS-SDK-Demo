//
//  UMSocialSnsViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-5-19.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "AppDelegate.h"
#import "UMSocialAFHTTPClient.h"
#import "UMImageView.h"
#import "UMUtils.h"

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
    NSString *shareText = [UMSocialData defaultData].shareText;
    UIImage *image = [UMSocialData defaultData].shareImage;
    [UMSocialSnsService presentSnsIconSheetView:self appKey:useAppkey shareText:shareText shareImage:image shareToSnsNames:nil delegate:nil];
}

-(IBAction)showShareList2:(id)sender
{
    NSString *shareText = [UMSocialData defaultData].shareText;
    UIImage *image = [UMSocialData defaultData].shareImage;
    [UMSocialSnsService presentSnsController:self appKey:useAppkey shareText:shareText shareImage:image shareToSnsNames:nil delegate:nil];
    
//    UINavigationController *navigationController = [[UMSocialControllerService defaultControllerService] getSocialShareListController];
//    [self presentModalViewController:navigationController animated:YES];
}

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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    //分享编辑页面的接口
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    
    //你可以这样根据不同的平台指定不同的内容
    if (buttonIndex == 1) {
        [UMSocialData defaultData].shareText = @"分享文字";
    }
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

- (void)viewDidLoad
{
    
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
