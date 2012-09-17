//
//  UMSocialDataAPI.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//
#import <Foundation/Foundation.h>
#import "UMSocialData.h"

@class CLLocation;

@interface UMSocialDataAPI : NSObject
{
    UMSocialData *_soicalData;
}

@property (nonatomic, retain) UMSocialData *socialData;

- (id)initWithUMSocialData:(UMSocialData *)socialData;

//- (void)setUMSoicalDelegate:(id <UMSocialDelegate>)delegate;

- (void)postSNSWithType:(UMShareToType)umShareType usid:(NSString *)usid content:(NSString *)content image:(UIImage *)image;

- (void)postCommentWithContent:(NSString *)content;

- (void)postCommentWithContent:(NSString *)content location:(CLLocation *)location shareToSNS:(NSArray *)shareToSNS;

- (void)requestCommentList:(NSInteger)lastCommentTime;

- (void)requestAddLikeOrCancel:(BOOL)isLike;

/* requestSocialAccount
 请求获取用户账号
 */
+ (void)requestSocialAccount;

/* requestUnOauthWithType
 请求解除授权
 */
+ (void)requestUnOauthWithType:(UMShareToType)shareToType;

/* requestBindToSnsWithType
 请求绑定账号
 */
+ (void)requestBindToSnsWithType:(UMShareToType)shareToType;

/* requestUnBindToSns
 请求解除绑定账号
 */
+ (void)requestUnBindToSns;

@end