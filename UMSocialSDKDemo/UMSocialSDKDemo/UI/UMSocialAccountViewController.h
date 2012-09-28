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
    UMAccountUnBind
}UMAccountAction;


@interface UMSocialAccountViewController : UITableViewController
<
    UIActionSheetDelegate,
        UMSocialDataDelegate
>
{
    UIActionSheet *_actionSheet;
    UMSocialControllerService *_socialUIController;
    UIActivityIndicatorView * _activityIndicatorView;
}
@end
