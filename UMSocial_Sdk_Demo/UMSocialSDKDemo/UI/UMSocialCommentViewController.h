//
//  UMSocialCommentViewController.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-1.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerServiceComment.h"

@interface UMSocialCommentViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
        UMSocialDataDelegate
>
{
    UITableView *_commentTableView;
    UMSocialControllerServiceComment *_socialController;
    UIImageView *_imageView;
    UIActivityIndicatorView * _activityIndicatorView;
}
@end
