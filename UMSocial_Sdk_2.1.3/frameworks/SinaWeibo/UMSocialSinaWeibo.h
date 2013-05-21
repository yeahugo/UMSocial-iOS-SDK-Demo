//
//  UMSocialSinaWeibo.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/19/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSinaWeiboRequest.h"

@protocol UMSocialSinaWeiboDelegate;

@interface UMSocialSinaWeibo : NSObject <UMSocialSinaWeiboRequestDelegate>
{
    NSString *userID;
    NSString *accessToken;
    NSDate *expirationDate;

    id<UMSocialSinaWeiboDelegate> __unsafe_unretained delegate;
    NSString *appKey;
    NSString *appSecret;
    NSString *appRedirectURI;
    NSString *ssoCallbackScheme;
    
    UMSocialSinaWeiboRequest *request;
    NSMutableSet *requests;
    BOOL ssoLoggingIn;
}

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *ssoCallbackScheme;
@property (nonatomic, unsafe_unretained) id<UMSocialSinaWeiboDelegate> delegate;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<UMSocialSinaWeiboDelegate>)delegate;

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecrect
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<UMSocialSinaWeiboDelegate>)delegate;

- (void)applicationDidBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;

// Log in using OAuth Web authorization.
// If succeed, sinaweiboDidLogIn will be called.
- (void)logIn;

// Log out.
// If succeed, sinaweiboDidLogOut will be called.
- (void)logOut;

- (BOOL)canLogIn;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;


// isLoggedIn && isAuthorizeExpired
- (BOOL)isAuthValid;

- (UMSocialSinaWeiboRequest *)requestWithURL:(NSString *)url
                             params:(NSMutableDictionary *)params
                         httpMethod:(NSString *)httpMethod
                           delegate:(id<UMSocialSinaWeiboRequestDelegate>)delegate;

@end


/**
 * @description 第三方应用需实现此协议，登录时传入此类对象，用于完成登录结果的回调
 */
@protocol UMSocialSinaWeiboDelegate <NSObject>

@optional

- (void)sinaweiboDidLogIn:(UMSocialSinaWeibo *)sinaweibo;
- (void)sinaweiboDidLogOut:(UMSocialSinaWeibo *)sinaweibo;
- (void)sinaweiboLogInDidCancel:(UMSocialSinaWeibo *)sinaweibo;
- (void)sinaweibo:(UMSocialSinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error;
- (void)sinaweibo:(UMSocialSinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error;

@end

extern BOOL SinaWeiboIsDeviceIPad();
