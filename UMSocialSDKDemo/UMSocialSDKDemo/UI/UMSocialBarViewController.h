//
//  UMSocialAccountViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-7.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialBar.h"

@interface UMSocialBarViewController : UIViewController
<
    UMSocialBarDelegate
>
{
    UMSocialBar *_socialBar;
    UILabel     *_textLabel;
}

-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image;
@end
