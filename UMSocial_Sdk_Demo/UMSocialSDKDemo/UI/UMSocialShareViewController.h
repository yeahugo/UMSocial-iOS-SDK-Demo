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

typedef enum
{
    UMShareList,
    UMShareEditPresent,
    UMSharePostData,
    UMSharePostMultiData
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
    UITableView *_shareTableView;
    UMSocialControllerService *_socialController;
    UIActionSheet *_editActionSheet;
    UIActionSheet *_dataActionSheet;
    UIImageView *_imageView;
    CLLocationManager *_locationManager;
    UIActivityIndicatorView * _activityIndicatorView;
}
@end
