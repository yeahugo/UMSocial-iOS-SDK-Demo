//
//  UMSocialBarViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialBar.h"

@interface UMSocialBarViewController : UIViewController<UMSocialBarDelegate>
{
    UMSocialBar *_socialBar;
    UILabel     *_textLabel;
    UIWebView   *_webView;
    NSInteger   _index;
}

-(id)initWithSocialData:(UMSocialData *)socialData withIndex:(NSInteger)index;

@end
