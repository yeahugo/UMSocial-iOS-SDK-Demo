//
//  UMSConfigManager.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-15.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialEnum.h"

#ifndef __IPHONE_6_0
typedef enum {
    UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
    UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
    UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
    UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
    UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
    UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
    UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
} UIInterfaceOrientationMask;
#endif

@interface UMSocialConfig : NSObject
{
    NSDictionary *_followSnsUids;
    BOOL    _shouldCommentWithShare;
    BOOL    _shouldCommentWithLocation;
    BOOL    _shouldShareSynchronous;
    NSArray *_snsPlatformNames;
    NSInteger _socialInterfaceOrientations;
    CGRect  _boundsForiPad;
    UIColor *_defaultColor;
}

@property (nonatomic, retain) NSArray *snsPlatformNames;
@property (nonatomic) NSInteger socialInterfaceOrientations;
@property (nonatomic, retain) NSDictionary *followSnsUids;
@property (nonatomic, assign) BOOL shouldCommentWithShare;
@property (nonatomic, assign) BOOL shouldCommentWithLocation;
@property (nonatomic, assign) BOOL shouldShareSynchronous;
@property (nonatomic, assign) CGRect boundsForiPad;
@property (nonatomic, retain) UIColor *defaultColor;

/**
 设置显示的sns平台类型
 
 @param platformNames  由`UMSocialEnum.h`定义的UMShareToSina、UMShareToTencent、UMShareToQzone、UMShareToRenren、UMShareToDouban、UMShareToEmail、UMShareToSms组成的NSArray
 */
+ (void)setSnsPlatformNames:(NSArray *)platformNames;

/**
设置sdk所有页面需要支持屏幕方向.

@param interfaceOrientations 一个bit map（位掩码），ios 6定义的`UIInterfaceOrientationMask`
*/
+ (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientations;

/**
 设置官方微博账号,设置之后可以在授权页面有关注微博的选项，默认勾选，授权之后用户即关注官方微博，仅支持新浪微博和腾讯微博
 
 @param weiboUids  腾讯微博和新浪微博的key分别是`UMShareToSina`和`UMShareToTenc`,值分别是官方微博的uid
 */
+ (void)setFollowWeiboUids:(NSDictionary *)weiboUids;

/**
 设置新增加`UMSocialSnsPlatform`对象 
 @param snsPlatformArray `UMSocialSnsPlatform`组成的数组对象
 
 */
+ (void)addSocialSnsPlatform:(NSArray *)snsPlatformArray;

/**
 设置页面的背景颜色
 @param defaultColor 设置页面背景颜色
 
 */
+ (void)setDefaultColor:(UIColor *)defaultColor;

/**
 设置iPad页面的大小
 @param size 页面大小
 
 */
+ (void)setBoundsSizeForiPad:(CGSize)size;

/**
 设置分享编辑页面是否等待完成之后再关闭页面还是立即关闭，如果设置成YES，就是等待分享完成之后再关闭，否则立即关闭。默认等待分享完成之后再关闭。如果设置成立即关闭的话，需要用`UMSocialDataServie`的`- (void)setUMSoicalDelegate:(id <UMSocialDataDelegate>)delegate;`来设置回调对象来获取分享是否成功，如果回调对象的`responseCode`为`UMSResponseCodeAccessTokenExpired`的话是授权过期，新浪微博对于不同应用的过期时间不一样，这种情况下要利用sdk提供的授权页面需要重新授权。

 @param 是否同步分享
 
 */
+ (void)setShouldShareSynchronous:(BOOL)shouldShareSynchronous;

/**
 设置评论页面是否出现分享按钮，默认出现

 */
+ (void)setShouldCommentWithShare:(BOOL)shouldCommentWithShare;

/**
 设置评论页面是否出现分享地理位置信息的按钮，默认出现
 
 */
+ (void)setShouldCommentWithLocation:(BOOL)shouldCommentWithLocation;

+ (UMSocialConfig *)shareInstance;

- (BOOL)shouldAutorotate;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
