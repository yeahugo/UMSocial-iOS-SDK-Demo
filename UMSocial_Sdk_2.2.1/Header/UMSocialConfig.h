//
//  UMSConfigManager.h
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-15.
//  Copyright (c) umeng.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialDataService.h"


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

/**
 SDK样式主题
 
 */
typedef enum {
    UMSocialThemeBlack,     //黑色主题
    UMSocialThemeWhite      //白色主题
} UMSocialTheme;


/**
 设置分享列表页面的Block类型
 
 @param ref 分享列表绘图所用的CGContext对象
 @param backgroundView 分享列表的背景图片
 
 */
typedef void (^UMGridViewConfig)(CGContextRef ref, UIImageView *backgroundView) ;

/**
 设置导航栏的样式的Block类型
 
 @param bar 导航栏
 @param closeButton 关闭按钮
 @param backButton 返回按钮
 @param postButton 发送按钮
 @param refreshButton 刷新按钮
 @param navigationItem 所在UINavigationController的navigationItem，可以改变相应的标题
 
 */
typedef void (^UMNavigationBarConfig)(UINavigationBar *bar,
        UIButton *closeButton,
        UIButton *backButton,
        UIButton *postButton,
        UIButton *refreshButton,
        UINavigationItem * navigationItem);

/**
 设置TableViewCell的样式
 
 @param cell UITableViewCell
 @param viewControllerType 页面类型
 
 */
typedef void (^UMTableViewCellConfig)(UITableViewCell *cell,UMSViewControllerType viewControllerType);

/**
 SDK设置类，负责改变SDK功能配置
 
 */
@interface UMSocialConfig : NSObject

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
 设置社会化组件UI主题，现在有黑色和白色两种
 
 @param theme UI主题
 
 */
+ (void) setTheme:(UMSocialTheme)theme;


/**
 设置分享列表页面，Block对象的形参包括有绘制当前线条的CGContex指针，icon背景视图
 例如下面写法
 ```
 [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView){
    CGContextSetRGBStrokeColor(ref, 0, 0, 0, 1.0);
    CGContextSetLineWidth(ref, 1.0);
    backgroundView.backgroundColor = [UIColor blackColor];
 }];
 ```
 @param gridViewConfig 设置分享列表样式的block对象
 
 */
+(void)setShareGridViewTheme:(UMGridViewConfig)gridViewConfig;

/**
 设置导航栏,包括导航栏的UINavigationBar,返回按钮，关闭按钮，发送按钮，刷新按钮和中间的UINavigationItem的样式
 例如下面写法：
 
 ```
 [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar,
     UIButton *closeButton,
     UIButton *backButton,
     UIButton *postButton,
     UIButton *refreshButton,
     UINavigationItem * navigationItem){
     UIImage * backgroundImage = [UIImage imageNamed:@"UMSocialSDKResourcesNew.bundle/OtherTheme/UMS_nav_bar_bg"];
 
     if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
         [bar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
     }
     bar.titleTextAttributes = nil;
 }];
 ```
 
 @param navigationConfig 设置导航栏样式的block对象
   navigationConfig 是一个Block对象，传入的参数包括：
     @param bar 导航栏
     @param closeButton 关闭按钮
     @param backButton 返回按钮
     @param postButton 发送按钮
     @param refreshButton 刷新按钮
     @param navigationItem 所在UINavigationController的navigationItem，可以改变相应的标题 
 */
+(void)setNavigationBarConfig:(UMNavigationBarConfig)navigationConfig;

/**
 设置分享列表页，个人中心页面等的UITableViewCell的样式
 
 @param tableViewCellConfig UITableViewCell的样式配置Block
     @param cell UITableViewCell
     @param viewControllerType 页面类型

 */
+(void)setTableViewCellConfig:(UMTableViewCellConfig)tableViewCellConfig;

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
 设置分享编辑页面是否等待完成之后再关闭页面还是立即关闭，如果设置成YES，就是等待分享完成之后再关闭，否则立即关闭。
 2.2版本前默认等待分享完成之后再关闭。
 2.2版本之后默认设置成立即关闭页面

 @param shouldShareSynchronous 是否同步分享
 
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

/**
 设置是否支持新浪微博SSO，默认支持

 */
+ (void)setSupportSinaSSO:(BOOL)supportSinaSSO;

@end
