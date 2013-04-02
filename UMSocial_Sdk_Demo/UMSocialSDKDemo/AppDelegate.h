//
//  AppDelegate.h
//  UMSocialSDKDemo
//
//  Created by yeahugo on 12-9-18.
//  Copyright (c) 2012年 yeahugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "UMSocialControllerService.h"

#define useAppkey @"507fcab25270157b37000010"

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    WXApiDelegate,
    UIActionSheetDelegate
>

@property (strong, nonatomic) UIWindow *window;

@end
