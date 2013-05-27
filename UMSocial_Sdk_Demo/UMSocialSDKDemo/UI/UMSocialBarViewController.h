//
//  UMSocialBarViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface UMSocialBarViewController : UIViewController<UMSocialBarDelegate>
{
    UMSocialBar *_socialBar;
    UIWebView   *_webView;
}

@end
