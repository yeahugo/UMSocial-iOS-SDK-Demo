//
//  UMSocialTableViewCell.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "UMSocialTableViewController.h"

@interface UMSocialTableViewCell : UITableViewCell <UMSocialDataDelegate>
{
    int _index;
    NSString *_descriptor;
    UMSocialControllerService *_socialController;
    UILabel  *_detailLabel;
    UIButton *_likeButton;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UMSocialTableViewController *_tabelViewController;
    UIImageView *_detailImageView;
}

@property (nonatomic) int index;
@property (nonatomic, copy) NSString *descriptor;
@property (nonatomic, readonly) NSString *labelText;
@property (nonatomic, readonly) UIImage *showImage;
@property (nonatomic, assign) UMSocialTableViewController *tableViewController;
@property (nonatomic, retain) UMSocialControllerService *socialController;

@end
