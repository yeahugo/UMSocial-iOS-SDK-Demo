//
//  UMSocialCommentViewController.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-9-1.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialDataAPI.h"
#import "UMSocialUIController.h"

@interface UMSocialCommentViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UMSocialDelegate
>
{
    UITableView *_commentTableView;
    UMSocialDataAPI *_socialAPI;
    UMSocialUIController *_socialController;
    UIImageView *_imageView;
}
@end
