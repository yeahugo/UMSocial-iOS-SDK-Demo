//
//  UMSocialSnsData.m
//  SocialSDK
//
//  Created by yeahugo on 13-11-25.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsData.h"
#import "UMSocialSnsPlatformManager.h"

@implementation UMSocialSnsData

@end

@implementation UMSocialSinaData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToSina;
    }
    return self;
}

@end

@implementation UMSocialTencentData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToTencent;
    }
    return self;
}

@end

@implementation UMSocialQzoneData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToQzone;
    }
    return self;
}

@end

@implementation UMSocialQQData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToQQ;
    }
    return self;
}

@end

@implementation UMSocialWechatSessionData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToWechatSession;
        self.wxMessageType = UMSocialWXMessageTypeNone;
    }
    return self;
}

@end

@implementation UMSocialWechatTimelineData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToWechatTimeline;
        self.wxMessageType = UMSocialWXMessageTypeNone;
    }
    return self;
}

@end

@implementation UMSocialRenrenData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToRenren;
    }
    return self;
}

@end


@implementation UMSocialDoubanData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToSina;
    }
    return self;
}

@end


@implementation UMSocialEmailData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToEmail;
    }
    return self;
}

@end


@implementation UMSocialSmsData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToSms;
    }
    return self;
}

@end


@implementation UMSocialFacebookData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToFacebook;
    }
    return self;
}

@end

@implementation UMSocialTwitterData

-(id)init
{
    self = [super init];
    if (self) {
        self.snsName = UMShareToTwitter;
    }
    return self;
}

@end