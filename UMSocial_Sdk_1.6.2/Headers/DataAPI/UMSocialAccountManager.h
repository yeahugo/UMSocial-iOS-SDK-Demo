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

/**
 添加自有账号到友盟的账号体系，一般是用户在使用自有账号登录之后，再利用此方法上传账号，然后利用我们评论和个人中心的接口就会显示自有账号的昵称和头像等信息
 
 @param customAccount 自有账号对象

 */
+(void)addCustomAccount:(UMSocialCustomAccount *)customAccount;

/**
 判断是否登录，此登录包括以游客身份登录，如果已经登录评论编辑页面点击发送就不会提示登录。
 */
+ (BOOL)isLogin;

/**
 判断是否用sns账号来登录，即绑定一个sns账号作为登录账号，如果是的话，个人中心页面上半部分和评论列表即显示此用户名、头像。
 */
+ (BOOL)isLoginWithSnsAccount;

/**
 判断是否授权此sns平台。
 
 @param platformType sns平台名，定义在`UMSocialEnum.h`
 */
+ (BOOL)isOauthWithPlatform:(NSString *)platformType;

/**
 账号管理，可以添加开发者应用的自有账号到友盟的账号体系，查询此sns平台是否授权等。
 */
+ (BOOL)isLoginWithAnonymous;

/**
 账号管理，可以添加开发者应用的自有账号到友盟的账号体系，查询此sns平台是否授权等。
 */
+ (void)setIsLoginWithAnonymous:(BOOL)anonymous;

@end
