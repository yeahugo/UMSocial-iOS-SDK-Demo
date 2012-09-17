//
//  UMSocialData.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UMSocialDelegate.h"

typedef enum{
    UMSNumberLike=0,
    UMSNumberShare,
    UMSNumberComment
}UMSNumberType;

@interface UMSocialData : NSObject
{
    NSString   *_identifier;
}

@property (nonatomic, copy) NSString *identifier;                      //每个UMSocialService对象的标识，应用内保证每个对象的descriptor唯一
@property (nonatomic, copy) NSString * shareText;                      //分享的内嵌文字
@property (nonatomic, copy) NSString * commentText;                    //用于用户在评论并分享的时候，该字段内容会自动添加到评论的后面，分享到各个分享平台
@property (nonatomic, retain) UIImage * shareImage;                    //分享的图片
@property (nonatomic, retain) UIImage * commentImage;                  //用于用户在评论并分享的时候，该字段内容会自动添加到评论中的图片，分享到各个分享平台

@property (nonatomic, readonly) BOOL isLike;

+ (void)setAppKey:(NSString *)appKey;

+ (void)openLog:(BOOL)openLog;

+ (UMSocialData *)defaultData;

+ (NSDictionary *)getUMSocialAccount;

- (id)initWithIdentifier:(NSString *)identifier;

- (NSInteger)getNumber:(UMSNumberType)numberType;

- (void)requestSocialData;

- (void)setUMSoicalDelegate:(id <UMSocialDelegate>)delegate;
@end
