//
//  UMSocialSnsPlatformManager.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSnsPlatform.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsService.h"

/*
 Sns平台类管理者类
 */
@interface UMSocialSnsPlatformManager : NSObject
{
    NSMutableDictionary *_allSnsPlatformDictionary;
    NSMutableDictionary *_snsPlatformDictionary;
    NSArray *_allSnsArray;
    NSArray *_allSnsValuesArray;
    NSArray *_socialSnsArray;
    NSDictionary        *_appInfo;
}

/**
 友盟应用对应各个平台的appkey和appsecret
 */
@property (nonatomic, retain) NSDictionary *appInfo;

/**
 sns平台配置数组，此数组可由调用者配置，可以在数组内嵌套数组设置分享列表页面多个分组
 */
@property (nonatomic, readonly) NSArray *allSnsArray;

/**
 sns平台配置数组，此数组由allSnsArray转换，只包含平台名作为元素
 */
@property (nonatomic, readonly) NSArray *allSnsValuesArray;

/**
 sns平台配置数组，此数组内只有social的云端sns分享平台名，云端分享的平台有新浪微博、腾讯微博、人人网、QQ空间、豆瓣。
 */
@property (nonatomic, readonly) NSArray *socialSnsArray;

/**
 该NSDictionary以各个平台名为key，UMSocialPlatform对象为value
 */
@property (nonatomic, retain) NSDictionary *allSnsPlatformDictionary;

/**
 `UMSocialSnsPlatformManager`的单例方法
 
 @return `UMSocialSnsPlatformManager`的单例对象
 */
+ (UMSocialSnsPlatformManager *)sharedInstance;


/**
 根据平台名，返回平台对象
 
 @param platformName sns平台名
 
 @return UMSocialSnsPlatform 平台对象
 */
+(UMSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)snsName;

/**
 把UMSocialSnsType类型转换成UMShareToSina、UMShareToTencent等平台名的字符串
 
 @param socialSnsType 平台枚举变量
 
 @return 平台名字符串
 */
+(NSString *)getSnsPlatformString:(UMSocialSnsType)socialSnsType;

/**
 把UMShareToSina、UMShareToTencent等平台名的字符串转换成平台枚举变量
 
 @param socialSnsString 平台名字符串
 
 @return 平台枚举变量
 */
+(UMSocialSnsType)getSnsPlatformType:(NSString *)socialSnsString;


/**
 把配置平台的次序号转换成平台名
 
 @param snsIndex 使用的平台顺序，使用的平台配置在UMSocialConfigDelegate,例如`- (NSArray *)shareToPlatforms;`返回的是UMSocialSnsTypeSina和UMSocialSnsTypeTenc,UMSocialSnsTypeSina就是0，UMSocialSnsTypeTenc就是1
 
 @return 平台名字符串
 */
+(NSString *)getSnsPlatformStringFromIndex:(NSInteger)snsIndex;

@end
