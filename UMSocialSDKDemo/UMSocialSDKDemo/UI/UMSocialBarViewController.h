//
//  UMSocialBarViewController.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialBar.h"

@interface UMSocialBarViewController : UIViewController
<
    UMSocialDataDelegate
>
{
    UMSocialBar *_socialBar;
    UILabel     *_textLabel;
}

-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image;
@end
