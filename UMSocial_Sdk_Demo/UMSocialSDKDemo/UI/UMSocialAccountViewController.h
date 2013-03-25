//
//  UMSocialAccountViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-7.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

typedef enum
{
    UMAccountSnsAccount,
    UMAccountSocialAccount,
    UMAccountLoginAccount,
    UMAccountSocialLogin,
    UMAccountOauth,
    UMAccountUnOauth,
    UMAccountSSO
}UMAccountAction;


@interface UMSocialAccountViewController : UITableViewController
<
    UIActionSheetDelegate,
    UMSocialDataDelegate,
    UMSocialUIDelegate
>
{
    UMSocialControllerService *_socialUIController;
    UIActivityIndicatorView * _activityIndicatorView;
    UMSocialSnsType _selectOauthType;
}
@end
