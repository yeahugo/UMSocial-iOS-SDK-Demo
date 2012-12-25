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

-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image
{
    self = [super initWithNibName:@"UMSocialBarViewController" bundle:nil];
    if (self) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:descriptor withTitle:@"socialBarTest"];
        _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        //下面这个设置为NO，分享列表出现短信、邮箱不需要登录
//        _socialBar.socialControllerService.shareNeedLogin = NO;
        //设置个人中心页面也不需要登录，默认需要。如果你单独使用UMSocialControllerService则默认不需要
//        _socialBar.socialControllerService.userCenterNeedLogin =NO;
        _socialBar.socialBarDelegate = self;
        _socialBar.socialBarView.themeColor = UMSBarColorBlack;
        SAFE_ARC_RELEASE(socialData);
        
        _socialBar.socialData.shareText = text;
        _socialBar.socialData.shareImage = image;
        _socialBar.socialData.commentImage = image;
        _socialBar.socialData.commentText = text;
        [self.view addSubview:_socialBar];
        _socialBar.center = CGPointMake(160, 391);
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        _textLabel.numberOfLines = 4;
        _textLabel.text = text;
        [self.view addSubview:_textLabel];
        
        UIButton *chageSocialBarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [chageSocialBarButton setFrame:CGRectMake(70, 100, 180, 50)];
        [chageSocialBarButton setTitle:@"更改操作栏的identifier" forState:UIControlStateNormal];
        [chageSocialBarButton addTarget:self action:@selector(changeSocialBarIdentifier:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:chageSocialBarButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
        imageView.image = image;
        [self.view addSubview:imageView];
        SAFE_ARC_RELEASE(imageView);
    }
    return self;
}

-(void)changeSocialBarIdentifier:(id)sender
{
    UIImage *image = _socialBar.socialData.shareImage;
    [_socialBar updateButtonNumberWithIdentifier:@"testNewSocialBar"];
    _socialBar.socialData.shareImage = image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}

@end
