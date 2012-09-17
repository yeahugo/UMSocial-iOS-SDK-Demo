//
//  UMSocialUIController.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-12.
//
//

#import <Foundation/Foundation.h>
#import "UMSocialData.h"
#import "UMSocialConfigDelegate.h"

@interface UMSocialUIController : NSObject
{
    UMSocialData *_socialData;
}

@property (nonatomic, retain) UMSocialData *socialData;

- (id)initWithUMSocialData:(UMSocialData *)socialData;

//- (void)setUMSocialDelegate:(id <UMSocialDelegate>)delegate;

- (void)addOrMinusLikeNumber;

- (void)presentShareList;

- (void)presentShareEdit:(UMShareToType)shareToType;

- (void)presentCommentList;

- (void)presentCommentEdit;

+ (void)setSocialConfigDelegate:(id <UMSocialConfigDelegate>)delegate;

+ (UIViewController *)getAccountViewController;

+ (UIViewController *)getLoginViewController;

+ (UIViewController *)getOauthViewController:(UMShareToType)shareToType;

@end


