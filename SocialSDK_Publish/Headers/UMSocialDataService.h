//
//  UMSocialDataAPI.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//
#import <Foundation/Foundation.h>
#import "UMSocialData.h"
#import "UMSocialDataDelegate.h"


@class CLLocation;

/**
 底层数据接口对象，用一个`UMSocialData`来初始化，此对象的方法有在直接发送微博、发送评论等。可以通过`socialData`属性来获取分享数、评论数，设置分享内嵌文字等。
 */
@interface UMSocialDataService : NSObject
{
    UMSocialData *_socialData;
}

///---------------------------------------
/// @name 属性
///---------------------------------------


/**
 通过`UMSocialData`对象，可以设置分享文字、图片，并获取到分享数、微博账号等属性
 */
@property (nonatomic, readonly) UMSocialData *socialData;

/**
 设置实现了`<UMSocialDataDelegate>`的对象
 */
@property (nonatomic, readonly) id <UMSocialDataDelegate> socialDataDelegate;

///---------------------------------------
/// @name 对象初始化和设置方法
///---------------------------------------

/**
 初始化一个`UMSocialDataService`对象
 
 @param socialData 一个`UMSocialData`对象
 
 @return 初始化对象
 */
- (id)initWithUMSocialData:(UMSocialData *)socialData;

/**
 设置实现了`<UMSocialDataDelegate>`的对象
 
 @param delegate 实现了`<UMSocialDataDelegate>`的对象
 
 */
- (void)setUMSoicalDelegate:(id <UMSocialDataDelegate>)delegate;

///---------------------------------------
/// @name 发送评论、分享、喜欢的网络请求
///---------------------------------------

/**
 发送微博内容到微博平台
 
 @param shareType 分享到的平台，为枚举变量类型
 @param usid      分享的usid，如果设置为nil的话，自动用本平台已经授权的usid
 @param content   分享的文字内容
 @param image     分享的图片
 @param location  分享的地理位置信息
 
 */
- (void)postSNSWithType:(UMShareToType)shareType usid:(NSString *)usid content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location;

/**
 发送评论
 
 @param content 评论的文字内容
 
 */
- (void)postCommentWithContent:(NSString *)content;

/**
 发送评论
 
 @param content 评论的文字内容
 @param location 评论的地理位置信息
 @param shareToSNS 评论并分享到微博平台，key为微博名，定义在`UMSocialEnum.h`中的`UMShareToSina`等，值为相应的usid
 
 */
- (void)postCommentWithContent:(NSString *)content location:(CLLocation *)location shareToSNSWithUsid:(NSDictionary *)shareToSNS;

/**
 获取评论
 
 @param lastCommentTime 如果要获取最新的评论数，设置为-1，如果获取指定评论，传入评论在这之前的时间戳
 
 @return description
 */
- (void)requestCommentList:(long long)lastCommentTime;

/**
 如果当前`UMSocialData`没有喜欢的话，发送喜欢，否则取消喜欢
 
 */
- (void)postAddLikeOrCancel;

///---------------------------------------
/// @name 用户账户信息相关网络请求
///---------------------------------------

/**
 请求获取用户微博账号的数据，获取到的用户数据在回调函数获得，也可以通过已经保存在本地并且更新的`socialData`属性的`soicalAccount`属性来获得
 
 */
- (void)requestSocialAccount;

/**
 请求解除授权
 
 @param shareToType 要解除授权的微博平台，此变量为枚举类型
 
 */
- (void)requestUnOauthWithType:(UMShareToType)shareToType;

/**
 请求绑定账号
 
 @param shareToType 要绑定账号的微博平台，此变量为枚举类型
 
 */
- (void)requestBindToSnsWithType:(UMShareToType)shareToType;

/**
 请求解除绑定账号
 
 */
- (void)requestUnBindToSns;

/**
 请求获取用户微博账号的详细数据,获取返回数据和其他方法一样，在<UMSocialDataDelegate>中的`didFinishGetUMSocialDataResponse`返回的`UMSocialResponseEntity`对象，数据部分是`data`属性，为`NSDictionary`类型
 
 @param shareToType 要获取微博信息的微博平台，此变量为枚举类型
 
 */
- (void)requestSnsInfomation:(UMShareToType)shareToType;

@end

