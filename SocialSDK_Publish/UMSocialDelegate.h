//
//  UMSocialDelegate.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-6.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSResponseEntity.h"

typedef enum {
    UMShareToTypeNone = -1,
    UMShareToTypeSina = 0,             //sina weibo
    UMShareToTypeTenc,                 //tencent weibo
    UMShareToTypeRenr,                 //renren
    UMShareToTypeDouban,               //douban
    UMShareToTypeCount,                //count the number of sns,now is 4
    UMShareToTypeMail = 10,
    UMShareToTypeSMS
} UMShareToType;


typedef enum {
	UMSResponseAddComment = 0,
    UMSResponseAddLike,
    UMSResponseGetCommentList,
    UMSResponseGetMoreCommentList,
    UMSResponseGetSocialInformation,
    UMSResponseShareToSNS,
    UMSResponseBinding,
    UMSResponseUnBinding,
    UMSResponseUnOauth,
    UMSResponseOauth,
    UMSResponseLogin,
    UMSResponseGetAccount,
} UMSResponse;

typedef enum {
    UMSResponseCodeSuccess            = 200,
    UMSResponseCodeGetNoUidFromOauth  = 5020,
    UMSResponseCodeAccessTokenExpired = 5027,
    UMSResponseCodeNetworkError       = 5050
} UMSResponseCode;

@protocol UMSocialDelegate <NSObject>

@optional
-(void)didFinishGetUMSocialResponse:(UMSResponseEntity *)response;

@end
