//
//  UMSocialStatistic.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//

#import <Foundation/Foundation.h>
#import "UMSocialDataDelegate.h"
#import <UIKit/UIKit.h>

/**
 用于实现统计功能类，用一个`identifier`标识符字符串来初始化，可以设置开发者自定义的用户id号，可以进行发送微博、评论或者添加喜欢的统计
 
 */
@class CLLocation;
@interface UMSocialStatistic : NSObject
{
    NSString *_identifier;
    NSString *_cuid;
}

///---------------------------------------
/// @name 对象属性
///---------------------------------------

/**
 标识一个`UMSocialStatistic`对象的标识符
 */
@property (nonatomic, copy, readonly) NSString *identifier;


///---------------------------------------
/// @name 初始化和设置方法
///---------------------------------------

/**
 初始化对象
 
 @param identifier 标识一个`UMSocialStatistic`对象的标识符
 @param cuid 开发者自定义的用户id号，方便进行统计，可以为空
 
 @return 初始化对象
 */
- (id)initWithIdentifier:(NSString *)identifier cuid:(NSString *)cuid;

/**
 设置友盟的appKey
 
 @param appKey 在友盟网站上获取到的appKey
 
 */
+ (void)setAppKey:(NSString *)appKey;

/**
 设置是否打开log
 
 @param openLog 是否打开log
 
 */
+ (void)openLog:(BOOL)openLog;

/**
 设置实现了`<UMSocialDataDelegate>`的对象
 
 @param delegate 实现了`<UMSocialDataDelegate>`的对象
 
 */
- (void)setUMSocialDelegate:(id <UMSocialDataDelegate>)delegate;

///---------------------------------------
/// @name 发送数据进行统计服务
///---------------------------------------

/**
 发送评论
 
 @param content 评论内容
 @param image 评论图片
 @param templateText 评论并发送到微博时跟在微博正文后的模板文字
 @param location 评论的地理位置信息
 @param shareToSNS 评论并发送到微博的平台和相应的uid组成的`NSDictionary`
 
 */
- (void)postCommentWithContent:(NSString *)content image:(UIImage *)image templateText:(NSString *)templateText location:(CLLocation *)location shareToSNSWithUsid:(NSDictionary *)shareToSNS;

/**
 发送分享，开发者在分享微博完成之后，得到微博id号后调用此方法
 
 @param shareToType 分享到的微博平台
 @param usid 分享的用户所在微博的uid
 @param content 分享的微博文字内容
 @param wid 分享成功后得到的微博id号
 @param location 分享微博的地理位置信息
 
 */
- (void)postSNSWithType:(UMShareToType)shareToType usid:(NSString *)usid content:(NSString *)content weiboId:(NSString *)wid location:(CLLocation *)location;

/**
 如果没有喜欢的话，发送喜欢，否则发送取消喜欢
 
 */
- (void)postAddLikeOrCancel;
@end
