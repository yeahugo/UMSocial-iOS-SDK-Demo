//
//  UMSResponseEntity.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-7-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMSResponseEntity : NSObject<NSCoding>
{
    int _st;                        //错误代号
    int _responseType;
    NSString *_message;             //返回的错误消息
    NSDictionary *_data;            //返回数据
    NSError *_error;
}

@property (nonatomic) int st;
@property (nonatomic) int responseType;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSError *error;

-(NSDictionary *)description;
@end
