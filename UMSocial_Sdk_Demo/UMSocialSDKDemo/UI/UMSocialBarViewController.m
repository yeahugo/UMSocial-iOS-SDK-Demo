//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialBarViewController.h"
#import "WXApi.h"
#import "UMSocialMacroDefine.h"
#import "UMStringMock.h"
#import "UMSocialShareViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "AppDelegate.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController

-(void)dealloc
{
    SAFE_ARC_RELEASE(_socialBar);
    SAFE_ARC_RELEASE(_textLabel);
    _socialBar.socialBarDelegate = nil;
    SAFE_ARC_SUPER_DEALLOC();
}

//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        closeButton.frame = CGRectMake(10, 10, 50, 30);
//        closeButton.titleLabel.text = @"title";
//        [closeButton addTarget:self action:@selector(closeMyself) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:closeButton];
//    }
//    return self;
//}

//-(void)closeMyself
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//        UMSocialControllerService *controllerService = [[UMSocialControllerService alloc] initWithUMSocialData:[UMSocialData defaultData]];
//        controllerService.socialData.shareText = @"亲们，分享一个好东东——#养生厨神iPhone版# 养生专家，尽在掌握！http://www.sythealth.com";
//        controllerService.socialData.shareImage = [UIImage imageNamed:@"Icon@2x.png"];
//        UINavigationController *navigationController = [controllerService getSocialShareListController];
//        [controllerService release];
//        [viewController presentModalViewController:navigationController animated:YES];
//    }];
//}

-(id)initWithSocialData:(UMSocialData *)socialData withIndex:(NSInteger)index
{
    self = [super initWithNibName:@"UMSocialBarViewController" bundle:nil];
    if (self) {
        _index = index;
        _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height - 110)];
    [self.view addSubview:_webView];
    
    NSString *text = [UMStringMock commentMockString];
    UIImage *image = [UIImage imageNamed:@"yinxing0"];
    
    _socialBar.socialBarDelegate = self;
    //        _socialBar.socialBarView.themeColor = UMSBarColorWhite;
    _socialBar.socialData.shareText = text;
    _socialBar.socialData.shareImage = image;
    _socialBar.socialData.commentImage = image;
    _socialBar.socialData.commentText = text;
    _socialBar.center = CGPointMake(size.width/2, size.height - 138);
    [self.view addSubview:_socialBar];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    UMSocialShareViewController *shareViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
    if (shareViewController.postsArray != nil) {
        [_webView loadHTMLString:[[shareViewController.postsArray objectAtIndex:_index] valueForKey:@"content"] baseURL:nil];
        
    }
    [_socialBar.socialControllerService.socialDataService requestSocialData];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);

    _socialBar.center = CGPointMake(size.height/2, size.width - 90 - _socialBar.frame.size.height + 5);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.height,size.width - 44 - 44)];
}

#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}

@end
