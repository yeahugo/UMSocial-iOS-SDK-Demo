//
//  UMSocialSnsService.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-8.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#define __UMSocial__Support__SSO 1

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"
#import "UMSocialConfig.h"
#import "WXApi.h"
#if __UMSocial__Support__SSO
#import "SinaWeibo.h"

#define kAppRedirectURI     @"http://sns.whalecloud.com/sina2/callback"

#endif

#define UMShareToWechatSession @"wxsession"
#define UMShareToWechatTimeline @"wxtimeline"

typedef void (^UMSocailAuthorization)(void);

/*
 实现快速分享，类方法传入相应的参数，既可以弹出分享列表。现在提供两种列表样式。
 */
@interface UMSocialSnsService : NSObject
<
    UIActionSheetDelegate,
    UMSocialUIDelegate,
#if __UMSocial__Support__SSO
    SinaWeiboDelegate,
#endif
    WXApiDelegate
>
{
    UMSocialControllerService *_socialControllerService;
    UIViewController *_presentingViewController;
    NSMutableArray *_snsArray;
    UMSocailAuthorization _authorization;
    UMSocialDataServiceCompletion _completion;
#if __UMSocial__Support__SSO
    SinaWeibo *_sinaWeibo;
#endif
}

#if __UMSocial__Support__SSO
@property (nonatomic, retain) SinaWeibo *sinaWeibo;
#endif

/**
 处理app的URL方法
 
 @param url 传入的url
 
 @return wxApiDelegate 实现微信代理对象
 */
+(BOOL)handleOpenURL:(NSURL *)url wxApiDelegate:(id<WXApiDelegate>)wxApiDelegate;

/**
 处理授权的Block对象
 
 */
@property (nonatomic, copy) UMSocailAuthorization authorization;

/**
 处理授权完成Block对象
 
 */
@property (nonatomic, copy) UMSocialDataServiceCompletion completion;

/**
 得到单例对象的类方法
  
 @return `UMSocialSnsService`的单例对象
 */
+ (UMSocialSnsService *)sharedInstance;

///---------------------------------------
/// @name 快速分享
///---------------------------------------

/**
 弹出一个分享列表的UITableViewController
 
 @param controller 在该controller弹出分享列表的UIActionSheet
 @param appKey 友盟appKey
 @param shareText  分享编辑页面的内嵌文字
 @param shareImage 分享内嵌图片,用户可以在编辑页面删除
 @param snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialEnum.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
 @param delegate 实现分享完成后的回调对象，如果不关注分享完成的状态，可以设为nil
 */
+(void)presentSnsController:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsNames:(NSArray *)snsNames delegate:(id <UMSocialUIDelegate>)delegate;

/**
 弹出一个分享列表的类似iOS6的UIActivityViewController控件
 
 @param controller 在该controller弹出分享列表的UIActionSheet
 @param appKey 友盟appKey
 @param shareText  分享编辑页面的内嵌文字
 @param shareImage 分享内嵌图片,用户可以在编辑页面删除
 @param snsNames 你要分享到的sns平台类型，该NSArray值是`UMSocialEnum.h`定义的平台名的字符串常量，有UMShareToSina，UMShareToTencent，UMShareToRenren，UMShareToDouban，UMShareToQzone，UMShareToEmail，UMShareToSms等
 @param delegate 实现分享完成后的回调对象，如果不关注分享完成的状态，可以设为nil
 */
+(void)presentSnsIconSheetView:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsNames:(NSArray *)snsNames delegate:(id <UMSocialUIDelegate>)delegate;


@end
