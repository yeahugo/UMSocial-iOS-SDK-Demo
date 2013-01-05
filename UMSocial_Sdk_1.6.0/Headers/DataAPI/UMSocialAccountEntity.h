//
//  UMSocialAccountEntity.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-7-13.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialEnum.h"

/**
 自定义的用户微博账户对象，对象数据从授权账号所对应的微博平台获取
 */
@interface UMSocialAccountEntity : NSObject<NSCoding>
{
    NSString *_platformName;
    NSString *_userName;
    NSString *_usid;
    NSString *_iconURL;
    NSString *_accessToken;
    NSString *_profileURL;
    UMSocialSnsType _shareToType;
    BOOL     _isFirstOauth;
}

/**
 微博平台名称,例如"sina"、"tencent",定义在`UMSocialEnum.h`
 */
@property (nonatomic, copy) NSString *platformName;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 用户授权后得到的accessToken
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 用户微博网址url
 */
@property (nonatomic, copy) NSString *profileURL;

/**
 微博平台类型
 */
@property (nonatomic, readonly) UMSocialSnsType shareToType;

/**
 是否首次授权，sdk内使用
 */
@property (nonatomic) BOOL isFirstOauth;

/**
 初始化方法
 
 @param platformName 微博平台名
 
 @return 初始化对象
 */
-(id)initWithPlatformName:(NSString *)platformName;

/**
 把各属性编码成NSString
 
 @return 一个`NSString`对象
 */
-(NSString *)description;

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

/**
 把配置平台的次序号转换成平台枚举名
 
 @param snsIndex 使用的平台顺序，使用的平台配置在UMSocialConfigDelegate,例如`- (NSArray *)shareToPlatforms;`返回的是UMSocialSnsTypeSina和UMSocialSnsTypeTenc,UMSocialSnsTypeSina就是0，UMSocialSnsTypeTenc就是1
 
 @return 平台枚举名
 */
+(UMSocialSnsType )getSnsPlatformTypeFromIndex:(NSInteger)snsIndex;
@end
