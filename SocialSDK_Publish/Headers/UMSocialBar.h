//
//  UMSocialBar.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//
#import "UMSocialData.h"
#import "UMSocialControllerService.h"

/**
 一个集成了多个社会化功能的工具栏，可以查看并添加评论、分享到微博、添加喜欢、查看用户信息等功能。
 你要用一个identifier标识符字符串和添加到的`UIViewController`对象来初始化，然后可以自己添加到你要添加到的`UIView`上，并自定义其位置。也可以通过他的socialData属性来获取分享数等。
 
 */
@interface UMSocialBar : UIView
<
    UMSocialDataDelegate,
    UMSocialUIDelegate
>
{
    UMSocialData *_socialData;
    UMSocialControllerService *_socialControllerService;
    UIViewController *_presentingViewController;
}

///---------------------------------------
/// @name 对象属性
///---------------------------------------

/**
 `UMSocialData`对象，可以通过该对象设置分享内嵌文字、图片，获取分享数等属性
 */
@property (nonatomic, readonly) UMSocialData *socialData;

/**
 `UMSocialControllerService`对象，可以通过该对象得到分享编辑页面等
 */
@property (nonatomic, readonly) UMSocialControllerService *socialControllerService;

/**
 `UMSocialBar`所弹出的分享页面要添加到的`UIViewController`对象
 */
@property (nonatomic, assign) UIViewController *presentingViewController;

///---------------------------------------
/// @name 初始化方法
///---------------------------------------

/**
 初始化方法
 
 @param socialData `UMSocialData`对象
 @param viewController `UMSocialBar`出现的分享列表、评论列表等`UINavigationCtroller`要添加到的`UIViewController`
 
 @return 初始化对象
 */
- (id)initWithUMSocialData:(UMSocialData *)socialData withViewController:(UIViewController *)viewController;

/**
 更新`UMSocialBar`按钮上的数字
 
 */
- (void)updateButtonNumber;
@end