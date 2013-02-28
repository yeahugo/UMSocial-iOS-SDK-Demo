//
//  UMSocialTabViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-1-25.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialTabBarController.h"
#import "UMSocialMacroDefine.h"
//#import "UMSocialCommentViewController.h"
#import "UMSocialShareViewController.h"
#import "UMSocialAccountViewController.h"
#import "UMSocialBarViewController.h"
#import "UMSocialTableViewController.h"
#import "UMSocialConfigViewController.h"

@implementation UMSocialTabBarController

- (void)viewDidLoad
{
    UMSocialShareViewController *shareViewController = [[UMSocialShareViewController alloc] initWithNibName:@"UMSocialShareViewController" bundle:nil];
    shareViewController.title = @"最新文章";
    shareViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_share"];
    
    UMSocialTableViewController *tableViewController = [[UMSocialTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.title = @"友盟博客";
    tableViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_mutilBar"];
    
    UINavigationController *tableNavigationContrller = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    SAFE_ARC_RELEASE(tableViewController);
    UMSocialAccountViewController *accountViewController = [[UMSocialAccountViewController alloc] init];
    accountViewController.title = @"个人账号";
    accountViewController.tabBarItem.image = [UIImage imageNamed:@"UMS_account"];
        
    UMSocialConfigViewController *configController = [[UMSocialConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
    configController.title = @"设置";
    configController.tabBarItem.image = [UIImage imageNamed:@"UMS_settings"];
    
    
    [self setViewControllers:[NSArray arrayWithObjects:shareViewController,tableNavigationContrller,accountViewController,configController,nil]];
    SAFE_ARC_AUTORELEASE(shareViewController);
    SAFE_ARC_AUTORELEASE(accountViewController);
    SAFE_ARC_AUTORELEASE(tableNavigationContrller);
    SAFE_ARC_AUTORELEASE(configController);
    
    [super viewDidLoad];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    for (UIViewController *viewController in self.viewControllers) {
        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    UMSocialConfigViewController *configViewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
    return configViewController.supportOrientationMask;
}

@end
