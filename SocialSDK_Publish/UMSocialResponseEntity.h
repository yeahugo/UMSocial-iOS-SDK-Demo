//
//  UMSocialResponseEntity.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-7-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialEnum.h"

/**
 返回的状态对象，可以通过此对象获取返回类型、返回结果、返回数据等。
 */
@interface UMSocialResponseEntity : NSObject<NSCoding>
{
    UMSResponseCode _responseCode;                        //错误代号
    UMSResponse _responseType;
    NSString *_message;             //返回的错误消息
    NSDictionary *_data;            //返回数据
    NSError *_error;
}

/**
 `UMSResponseCode`状态码,定义在`UMSocialEnum`
 
  @see `UMSocialEnum.h`
 */
@property (nonatomic) UMSResponseCode responseCode;

/**
 数据返回`UMSResponse`类型,定义在`UMSocialEnum`
 
 @see `UMSocialEnum.h`
 */
@property (nonatomic) UMSResponse responseType;

/**
 错误原因
 */
@property (nonatomic, retain) NSString *message;

/**
 返回数据
 */
@property (nonatomic, retain) NSDictionary *data;

/**
 客户端发送出现的错误
 */
@property (nonatomic, retain) NSError *error;

/**
 把各属性编码成NSDictionary
  
 @return 一个`NSDictionary`对象
 */
-(NSDictionary *)description;
@end
