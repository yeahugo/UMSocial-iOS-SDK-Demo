//
//  UMSocialCommentViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-1.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

@interface UMSocialCommentViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
        UMSocialDataDelegate
>
{
    UITableView *_commentTableView;
    UMSocialControllerService *_socialController;
    UIImageView *_imageView;
}
@end
