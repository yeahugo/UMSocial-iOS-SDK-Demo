//
//  UMSocialTableViewCell.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerServiceComment.h"
#import "UMSocialTableViewController.h"

@interface UMSocialTableViewCell : UITableViewCell <UMSocialDataDelegate,UMSocialUIDelegate>
{
//    int _index;
    NSString *_descriptor;
    UMSocialControllerServiceComment *_socialController;
    UILabel  *_detailLabel;
    UIButton *_likeButton;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UMSocialTableViewController *__unsafe_unretained _tabelViewController;
    UIImageView *_detailImageView;
}

//@property (nonatomic) int index;
@property (nonatomic, copy) NSString *descriptor;
@property (nonatomic, readonly) NSString *labelText;
@property (nonatomic, readonly) UIImage *showImage;
@property (nonatomic, unsafe_unretained) UMSocialTableViewController *tableViewController;

@property (nonatomic, retain) UMSocialControllerService *socialController;

@end
