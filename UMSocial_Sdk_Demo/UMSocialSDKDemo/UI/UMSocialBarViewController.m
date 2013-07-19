//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialBarViewController.h"
#import "UMSocialSnsViewController.h"
#import "AppDelegate.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController

- (void)viewDidLoad
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);
    
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialDemo"];
    socialData.shareText = @"友盟社会化分享 http://www.umeng.com";         //分享内嵌文字
    socialData.shareImage = [UIImage imageNamed:@"icon.png"];           //分享内嵌图片
    _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
    _socialBar.socialUIDelegate = self;
    _socialBar.center = CGPointMake(size.width/2, size.height - 93);
    [self.view addSubview:_socialBar];
    
    UMSocialSnsViewController *snsViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    if (snsViewController.postsDic != nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height - 44 * 2 - _socialBar.frame.size.height)];
        [self.view addSubview:_webView];
        [_webView loadHTMLString:[snsViewController.postsDic  valueForKey:@"content"] baseURL:nil];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
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
    float barHeight = 44;
    _socialBar.center = CGPointMake(size.height/2, size.width  - barHeight - _socialBar.frame.size.height );
    
    _webView.frame = CGRectMake(0, 0, size.height, size.width -  barHeight * 2 - _socialBar.frame.size.height);
}

@end
