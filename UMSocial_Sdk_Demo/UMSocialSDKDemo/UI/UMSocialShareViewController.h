//
//  UMSocialShareViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-22.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import <CoreLocation/CoreLocation.h>
#import "UMImageView.h"

typedef enum
{
    UMShareList,
    UMShareIconActionSheet,
    UMShareEditPresent,
    UMSharePostData,
    UMSharePostMultiData,
}UMShareAction;

@interface UMSocialShareViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UIActionSheetDelegate,
    UMSocialDataDelegate,
    UMSocialUIDelegate
>
{
    UMSocialControllerService *_socialController;
    UIButton *_shareButton1;
    UIButton *_shareButton2;
    UIButton *_shareButton3;
    UIWebView *_webView;
    CLLocationManager *_locationManager;
    UIActivityIndicatorView * _activityIndicatorView;
    NSArray *_postsArray;
}

@property (nonatomic, retain) NSArray *postsArray;
@end
