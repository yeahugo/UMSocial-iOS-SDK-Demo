//
//  UMSocialTableViewCell.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"
#import "UMSocialTableViewController.h"

@interface UMSocialTableViewCell : UITableViewCell <UMSocialDataDelegate,UMSocialUIDelegate>
{
    int _index;
    NSString *_descriptor;
    UMSocialControllerService *_socialController;
    UILabel  *_detailLabel;
    UIButton *_likeButton;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UMSocialTableViewController *__unsafe_unretained _tabelViewController;
    UIImageView *_detailImageView;
}

@property (nonatomic) int index;
@property (nonatomic, copy) NSString *descriptor;
@property (unsafe_unretained, nonatomic, readonly) NSString *labelText;
@property (unsafe_unretained, nonatomic, readonly) UIImage *showImage;
@property (nonatomic, unsafe_unretained) UMSocialTableViewController *tableViewController;
@property (nonatomic, strong) UMSocialControllerService *socialController;

@end
