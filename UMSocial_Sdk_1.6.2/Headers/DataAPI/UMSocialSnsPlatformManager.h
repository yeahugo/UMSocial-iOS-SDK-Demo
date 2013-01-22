//
//  UMSocialSnsPlatformManager.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialSnsPlatform.h"

@interface UMSocialSnsPlatformManager : NSObject
{
    NSMutableDictionary *_allSnsPlatformDictionary;
    NSMutableDictionary *_snsPlatformDictionary;
    NSArray *_allConfigArray;
    NSArray *_allConfigArrayValues;
}

@property (nonatomic, retain) NSMutableDictionary * allSnsPlatformDictionary;
@property (nonatomic, retain) NSMutableDictionary * snsPlatformDictionary;
@property (nonatomic, readonly) NSArray *allConfigArray;
@property (nonatomic, readonly) NSArray *allConfigArrayValues;

+ (UMSocialSnsPlatformManager *)sharedInstance;

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
