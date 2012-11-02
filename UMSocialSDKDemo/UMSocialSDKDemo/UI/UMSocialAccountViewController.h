//
//  UMSocialAccountViewController.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-7.
//
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
    UMAccountFriend
}UMAccountAction;


@interface UMSocialAccountViewController : UITableViewController
<
    UIActionSheetDelegate,
    UMSocialDataDelegate,
    UMSocialUIDelegate
>
{
    UIActionSheet *_actionSheet;
    UMSocialControllerService *_socialUIController;
    UIActivityIndicatorView * _activityIndicatorView;
}
@end
