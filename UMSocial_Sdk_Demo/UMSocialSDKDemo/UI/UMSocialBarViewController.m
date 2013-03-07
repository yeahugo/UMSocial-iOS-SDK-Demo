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
    SAFE_ARC_RELEASE(_textLabel);
    _socialBar.socialBarDelegate = nil;
    SAFE_ARC_RELEASE(_socialBar);
    SAFE_ARC_SUPER_DEALLOC();
}

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
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height - 130)];
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
    [_socialBar.socialControllerService.socialDataService requestSocialDataWithCompletion:nil];
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
    float barHeight = 44;
    _socialBar.center = CGPointMake(size.height/2, size.width - 44 - barHeight - _socialBar.frame.size.height );
    
    _webView.frame = CGRectMake(0, 0, size.height, size.width - 44 - barHeight - _socialBar.frame.size.height);
}

#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}

@end
