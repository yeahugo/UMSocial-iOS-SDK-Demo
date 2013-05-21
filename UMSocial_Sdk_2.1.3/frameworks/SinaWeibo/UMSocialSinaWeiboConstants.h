//
//  SinaWeiboConstants.h
//  sinaweibo_ios_sdk
//
//  Created by Wade Cheng on 4/22/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#ifndef umsocial_sinaweibo_ios_sdk_SinaWeiboConstants_h
#define umsocial_sinaweibo_ios_sdk_SinaWeiboConstants_h

#define UMSocialSinaWeiboSdkVersion                @"2.0"

#define kUMSocialSinaWeiboSDKErrorDomain           @"SinaWeiboSDKErrorDomain"
#define kUMSocialSinaWeiboSDKErrorCodeKey          @"SinaWeiboSDKErrorCodeKey"

#define kUMSocialSinaWeiboSDKAPIDomain             @"https://open.weibo.cn/2/"
#define kUMSocialSinaWeiboSDKOAuth2APIDomain       @"https://open.weibo.cn/2/oauth2/"
#define kUMSocialSinaWeiboWebAuthURL               @"https://open.weibo.cn/2/oauth2/authorize"
#define kUMSocialSinaWeiboWebAccessTokenURL        @"https://open.weibo.cn/2/oauth2/access_token"

#define kUMSocialSinaWeiboAppAuthURL_iPhone        @"sinaweibosso://login"
#define kUMSocialSinaWeiboAppAuthURL_iPad          @"sinaweibohdsso://login"

typedef enum
{
	kUMSocialSinaWeiboSDKErrorCodeParseError = 200,
	kUMSocialSinaWeiboSDKErrorCodeSSOParamsError = 202,
} UMSocialSinaWeiboSDKErrorCode;

#endif
