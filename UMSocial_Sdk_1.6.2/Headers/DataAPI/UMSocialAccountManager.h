//
//  UMSocialAccountManager.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialEnum.h"

extern NSString *const UMSCustomAccountGenderMale;

extern NSString *const UMSCustomAccountGenderFeMale;

/**
 开发者自有账户对象，在app登录或者注册完成之后用用户名来初始化这样的对象，可以指定头像等，然后用`UMSocialAccountManager`来添加到友盟的账户体系上，使用我们的评论列表和个人中心的页面时就会显示自有账号的用户名和头像
 */
@interface UMSocialCustomAccount : NSObject
{
    NSString *_userName;
    NSString *_usid;
    NSString *_gender;
    NSDate *_birthday;
    NSString *_profileUrl;
    NSString *_iconUrl;
    NSDictionary *_customData;
}

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *usid;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic, copy) NSString *profileUrl;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, retain) NSDictionary *customData;

-(id)initWithUserName:(NSString *)userName;

@end

/**
 账号管理，可以添加开发者应用的自有账号到友盟的账号体系，查询此sns平台是否授权等。
 */
@interface UMSocialAccountManager : NSObject

+(void)addCustomAccount:(UMSocialCustomAccount *)customAccount;

#pragma query api
+ (BOOL)isLogin;
+ (BOOL)isLoginWithSnsAccount;
+ (BOOL)isOauthWithPlatform:(NSString *)platformType;

+ (BOOL)isLoginWithAnonymous;

+ (void)setIsLoginWithAnonymous:(BOOL)anonymous;

@end
