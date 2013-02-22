//
//  UMSocialTabViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-1-25.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialTabBarController.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialCommentViewController.h"
#import "UMSocialShareViewController.h"
#import "UMSocialAccountViewController.h"
#import "UMSocialBarViewController.h"
#import "UMSocialTableViewController.h"
#import "UMSocialConfigViewController.h"

@implementation UMSocialTabBarController

- (void)viewDidLoad
{
    UMSocialShareViewController *shareViewController = [[UMSocialShareViewController alloc] initWithNibName:@"UMSocialShareViewController" bundle:nil];
    shareViewController.title = @"分享";
    shareViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_share"];
    
    UMSocialAccountViewController *accountViewController = [[UMSocialAccountViewController alloc] init];
    accountViewController.title = @"个人账号";
    accountViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_account"];
    
    UMSocialCommentViewController *commentViewController = [[UMSocialCommentViewController alloc] init];
    commentViewController.title = @"评论";
    commentViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_comment"];

    UMSocialBarViewController *barViewController = [[UMSocialBarViewController alloc] init];
    barViewController.title = @"操作栏";
    barViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_bar"];
    
    UMSocialConfigViewController *configController = [[UMSocialConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
    configController.title = @"设置";
    configController.tabBarItem.image = [UIImage imageNamed:@"UMS_settings"];
    
    
//    UMSocialTableViewController *tableViewController = [[UMSocialTableViewController alloc] init];
//    tableViewController.title = @"操作栏分拆接口";
//    tableViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_mutilBar"];
    
    [self setViewControllers:[NSArray arrayWithObjects:shareViewController,accountViewController,commentViewController,barViewController,configController,nil]];
    SAFE_ARC_AUTORELEASE(shareViewController);
    SAFE_ARC_AUTORELEASE(accountViewController);
    SAFE_ARC_AUTORELEASE(commentViewController);
    SAFE_ARC_AUTORELEASE(barViewController);
    SAFE_ARC_AUTORELEASE(configController);
    
    [super viewDidLoad];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (UIViewController *viewController in self.viewControllers) {
        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    UMSocialConfigViewController *configViewController = [self.viewControllers objectAtIndex:4];
    return configViewController.supportOrientationMask;
}

@end
