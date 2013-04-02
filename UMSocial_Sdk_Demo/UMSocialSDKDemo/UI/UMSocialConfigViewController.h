//
//  UMSocialConfigViewController.h
//  SocialSDK
//
//  Created by yeahugo on 13-2-18.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialControllerService.h"

@interface UMSocialConfigViewController : UITableViewController
{
    UIInterfaceOrientationMask _supportOrientationMask;
    NSMutableArray *_shareToPlatforms;
    NSArray *_shareToPlatformsValues;
    NSMutableDictionary *_shareToPlatformDic;
}

@property (nonatomic, assign) UIInterfaceOrientationMask supportOrientationMask;
@end
