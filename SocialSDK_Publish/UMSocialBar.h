//
//  UMSocialBar.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//
#import "UMSocialConfigDelegate.h"
#import "UMSocialData.h"

@interface UMSocialBar : UIView
{
    UMSocialData *_socialData;
}

@property (nonatomic, retain) UMSocialData *socialData;

- (id)initWithUMSocialData:(UMSocialData *)socialData;

- (void)updateButtonNumber;

+(void)setSocialConfigDelegate:(id <UMSocialConfigDelegate>)delegate;
@end