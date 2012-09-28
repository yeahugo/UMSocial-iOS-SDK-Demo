//
//  UMSocialShareViewController.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-22.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

typedef enum
{
    UMShareEditPresent,
    UMShareOauthPresent,
    UMSharePostData
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
    UIActionSheet *_actionSheet;
    UIImageView *_imageView;
}
@end
