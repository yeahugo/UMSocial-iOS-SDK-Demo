//
//  UMSnsAccountEntity.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-7-13.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialDelegate.h"

@interface UMSnsAccountEntity : NSObject<NSCoding>
{
    NSString *_platformName;
    NSString *_userName;
    NSString *_usid;
    NSString *_iconURL;
    NSString *_accessToken;
    NSString *_profileURL;
    UMShareToType _shareToType;
    BOOL     _isFirstOauth;
}

@property (nonatomic, copy) NSString *platformName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *usid;
@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *profileURL;
@property (nonatomic, readonly) UMShareToType shareToType;
@property (nonatomic) BOOL isFirstOauth;

-(id)initWithPlatformName:(NSString *)platformName;
@end
