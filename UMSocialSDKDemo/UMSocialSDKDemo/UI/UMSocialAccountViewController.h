//
//  UMSocialAccountViewController.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-7.
//
//

#import <UIKit/UIKit.h>
#import "UMSocialUIController.h"
#import "UMSocialDataAPI.h"

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
    UMSocialDelegate
>
{
    UIActionSheet *_actionSheet;
}
@end
