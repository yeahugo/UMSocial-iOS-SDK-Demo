//
//  UMSocialStatistic.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//

#import <Foundation/Foundation.h>
#import "UMSocialDelegate.h"

@class CLLocation;
@interface UMSocialStatistic : NSObject
{
    NSString *_identifier;
    NSString *_cuid;
}

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *cuid;

+ (void)setAppKey:(NSString *)appKey;

+ (void)openLog:(BOOL)openLog;

- (id)initWithIdentifier:(NSString *)identifier cuid:(NSString *)cuid;

- (void)setUMSocialDelegate:(id <UMSocialDelegate>)delegate;

- (void)postCommentWithContent:(NSString *)content location:(CLLocation *)location shareToSNSWithUsid:(NSDictionary *)shareToSNS;

- (void)postSNSWithType:(UMShareToType)umShareType usid:(NSString *)usid content:(NSString *)content weiboId:(NSString *)wid;

- (void)addOrMinusLikeNumber;
@end
