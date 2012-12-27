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
    UMAccountOauth,
    UMAccountUnOauth,
    UMAccountBind,
    UMAccountUnBind,
    UMAccountSnsInfo,
    UMAccountFriend,
    UMAccountAddFollow
}UMAccountAction;


@interface UMSocialAccountViewController : UITableViewController
<
    UIActionSheetDelegate,
    UMSocialDataDelegate,
    UMSocialUIDelegate
>
{
    UIActionSheet *_actionSheet;
    UMSocialData *_socialData;
    UMSocialControllerService *_socialUIController;
    UIActivityIndicatorView * _activityIndicatorView;
    UMSocialSnsType _selectOauthType;
    
    UILabel *_nickNameLabel;
    UILabel *_accessTokenLable;
}
@end
