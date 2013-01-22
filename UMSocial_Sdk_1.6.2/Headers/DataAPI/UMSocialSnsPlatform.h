//
//  SCSnsDescriptor.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 5/3/12.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialEnum.h"

@class UMSocialControllerService;

typedef void (^UMSocialSnsPlatformClickHandler)(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController);

@interface UMSocialSnsPlatform : NSObject
{
	NSString	*_protocolName;			// sina tentcent renren douban
	NSString	*_oauthBaseURLString;	//
	NSString	*_oauthCallBackPath;
	NSString	*_snsName;			// 编辑显示名称
    NSString    *_loginName;            // 登陆显示名称
    NSString    *_imageName;            // icon的图片名
    NSString    *_imageOffName;         // 没有绑定的图片名
    NSString    *_imageOnName;          // 绑定的图片名
	UMSocialSnsType _shareToType;
    UMSocialSnsPlatformClickHandler _snsClickHandler;
}

@property (nonatomic, copy) NSString	*protocolName;
@property (nonatomic, copy) NSString	*oauthBaseURLString;
@property (nonatomic, copy) NSString	*oauthCallBackPath;
@property (nonatomic, copy) NSString	*snsName;
@property (nonatomic, copy) NSString    *loginName;
@property (nonatomic, assign) UMSocialSnsType shareToType;

@property (nonatomic, copy) NSString    *imageName;
@property (nonatomic ,copy) NSString    *imageOffName;
@property (nonatomic, copy) NSString    *imageOnName;

@property(nonatomic, copy) UMSocialSnsPlatformClickHandler snsClickHandler;

@end