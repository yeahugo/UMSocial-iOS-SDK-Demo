//
//  UMSocialDataAPI.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-13.
//  Copyright (c) umeng.com All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UMSocialData.h"
#import "UMSocialDataDelegate.h"

typedef void (^UMSocialDataServiceCompletion)(UMSocialResponseEntity * response);

@class CLLocation;

/**
 底层数据接口对象，用一个`UMSocialData`来初始化，此对象的方法有在直接发送微博、发送评论等。可以通过`socialData`属性来获取分享数、评论数，设置分享内嵌文字等。
 */
@interface UMSocialDataService : NSObject
{
    UMSocialData *_socialData;
    UMSocialDataServiceCompletion _completion;
}

///---------------------------------------
/// @name 属性
///---------------------------------------


@property (nonatomic, copy) UMSocialDataServiceCompletion completion;

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

/*!
 设置实现了`<UMSocialDataDelegate>`的对象， 如果在此视图设置了delegate，离开此视图的时候要设置为nil
 
 @param delegate 实现了`<UMSocialDataDelegate>`的对象
 
 */
- (void)setUMSocialDelegate:(id <UMSocialDataDelegate>)delegate;

///---------------------------------------
/// @name 获取评论、分享、喜欢个数，发送评论、分享、喜欢的网络请求
///---------------------------------------

/**
 从服务器获取分享数、评论数、喜欢数等属性
 @param completion 获取到数据之后执行的block对象
 
 */
- (void)requestSocialDataWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 发送微博内容到微博平台
 
 @param platformType   分享到的平台名，在`UMSocialEnum.h`中定义好的字符串常量
 @param content   分享的文字内容
 @param image     分享的图片
 @param location  分享的地理位置信息
 @param completion 发送数据之后执行的block对象
 
 */
- (void)postSNSWithType:(NSString *)platformType content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location completion:(UMSocialDataServiceCompletion)completion;


/**
 发送微博内容到多个微博平台
 
 @param platformTypes 分享到的平台，数组的元素是`UMSocialEnum.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
 @param content   分享的文字内容
 @param image     分享的图片
 @param location  分享的地理位置信息
 @param urlResource  图片、音乐、视频等url资源
 @param completion 发送完成执行的block对象
 
 */
- (void)postSNSWithTypes:(NSArray *)platformTypes content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location urlResource:(UMSocialUrlResource *)urlResource  completion:(UMSocialDataServiceCompletion)completion;


/**
 如果当前`UMSocialData`没有喜欢的话，发送喜欢，否则取消喜欢
 
 @param completion 获取到数据之后执行的block对象
 
 */
- (void)postAddLikeOrCancelWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 发送评论
 
 @param content 评论的文字内容
 @param completion 获取到数据之后执行的block对象
 
 */
- (void)postCommentWithContent:(NSString *)content completion:(UMSocialDataServiceCompletion)completion;

/**
 发送评论
 
 @param content 评论的文字内容
 @param image 评论并发送到微博的图片
 @param templateText 评论并发送到微博跟在微博正文后面用//分隔的文字
 @param location 评论的地理位置信息
 @param shareToSNS 评论并分享到微博平台，key为微博名，定义在`UMSocialEnum.h`中的`UMShareToSina`等，值为相应的usid
 @param completion 获取到数据之后执行的block对象
 
 */
-(void)postCommentWithContent:(NSString *)content image:(UIImage *)image templateText:(NSString *)templateText location:(CLLocation *)location shareToSNSWithUsid:(NSDictionary *)shareToSNS completion:(UMSocialDataServiceCompletion)completion;

/**
 获取评论
 
 @param lastCommentTime 如果要获取最新的评论数，设置为-1，如果获取指定评论，传入评论在这之前的时间戳
 @param completion 获取到数据之后执行的block对象，此block对象的形参内带有请求的评论数据
 
 */
- (void)requestCommentList:(long long)lastCommentTime completion:(UMSocialDataServiceCompletion)completion;

///---------------------------------------
/// @name 用户账户信息相关网络请求
///---------------------------------------

/**
 请求获取用户微博账号的数据，获取到的用户数据在回调函数获得，也可以通过已经保存在本地并且更新的`socialData`属性的`soicalAccount`属性来获得
  @param completion 获取到数据之后执行的block对象，此block对象的形参带啊有请求的用户账号数据
 
 */
- (void)requestSocialAccountWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 请求解除授权
 
 @param platformType 要解除授权的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestUnOauthWithType:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求绑定账号
 
 @param platformType 要绑定账号的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestBindToSnsWithType:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求解除绑定账号
 @param completion 请求之后执行的block对象
 
 */
- (void)requestUnBindToSnsWithCompletion:(UMSocialDataServiceCompletion)completion;

/**
 请求获取用户微博账号的详细数据,获取返回数据和其他方法一样，在<UMSocialDataDelegate>中的`didFinishGetUMSocialDataResponse`返回的`UMSocialResponseEntity`对象，数据部分是`data`属性，为`NSDictionary`类型
 
 @param platformType 要获取微博信息的微博平台
 @param completion 请求之后执行的block对象
 
 */
- (void)requestSnsInformation:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求获取用户微博账号的朋友列表,获取返回数据和其他方法一样，在<UMSocialDataDelegate>中的`didFinishGetUMSocialDataResponse`返回的`UMSocialResponseEntity`对象，数据部分是`data`属性，为`NSDictionary`类型
 
 @param platformType 要获取微博信息的微博平台
 @param completion 请求之后执行的block对象,block对象的形参内带有请求的好友数据
 
 */
- (void)requestSnsFriends:(NSString *)platformType completion:(UMSocialDataServiceCompletion)completion;

/**
 请求添加关注
 
 @param platformType 要添加关注的微博平台，目前添加关注功能只支持新浪微博和腾讯微博
 
 @param usids 被关注的usid号
 
 @param completion 请求之后执行的block对象
 
 */
- (void)requestAddFollow:(NSString *)platformType followedUsid:(NSArray *)usids completion:(UMSocialDataServiceCompletion)completion;

/**
 每个post和request方法都会把请求放到一个队列上，取消队列所有请求
  
 */
- (void)cancelAllRequestInQueue;
@end

