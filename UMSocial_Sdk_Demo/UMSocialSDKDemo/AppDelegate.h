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

#define UmengAppkey @"5211818556240bc9ee01db2f"

@interface AppDelegate : UIResponder
<
    UIApplicationDelegate,
    WXApiDelegate,
    UIActionSheetDelegate
>

@property (strong, nonatomic) UIWindow *window;

@end
