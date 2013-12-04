//
//  UMSocialShakeService.h
//  SocialSDK
//
//  Created by yeahugo on 13-11-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

/**
 响应摇一摇动作后的配置类型，是否显示截屏，是否显示分享编辑框，是否发出音效等等。
 
 */
typedef enum {
    UMSocialShakeConfigNone                    = 0,               //摇一摇之后不显示任何效果和发出声音
    UMSocialShakeConfigShowScreenShot          = 1 << 0,          //显示截屏图片
    UMSocialShakeConfigShowShareEdit           = 1 << 1,          //显示分享编辑框
    UMSocialShakeConfigSound                   = 1 << 2,          //发出摇一摇音效
    UMSocialShakeConfigSupportOrientation      = 1 << 3,          //设置是否支持旋转屏幕，默认支持
    UMSocialShakeConfigDefault                 = UMSocialShakeConfigShowScreenShot | UMSocialShakeConfigShowShareEdit
    | UMSocialShakeConfigSound | UMSocialShakeConfigSupportOrientation                                   //默认显示截屏图片、显示分享编辑框，支持旋转，发出摇一摇音效
} UMSocialShakeConfig;

@class UMSocialData;

@class UMSocialResponseEntity;

@class UMSocialScreenShoter;

/**
 响应摇一摇动作的代理方法
 
 */
@protocol UMSocialShakeDelegate <NSObject>

@optional

/**
 摇一摇分享完成后获得的回调方法
 
 @param response 分享结果对象
 
 */
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response;

/**
 点击分享按钮或者关闭页面的按钮后的回调方法
 
 */
-(void)didCloseShakeView;

/**
 摇一摇后得到的回调方法
 
 @return 摇一摇分享的配置，可以设置是否弹出编辑框，是否显示截图，是否有声音，见'UMSocialShakeConfig'的定义
 */
-(UMSocialShakeConfig)didShakeWithShakeConfig;

@end

/**
 设置监听摇一摇动作的类
 
 */
@interface UMSocialShakeService : NSObject <UIAccelerometerDelegate>

/**
 设置响应摇一摇事件，并且弹出分享页面
 
 @param snsTypes 要分享的平台类型名，例如@[UMShareToSina,UMShareToTencent,UMShareToWechatSession]
 @param shareText 分享内嵌文字
 @param screenShoter 摇一摇分享用到的截屏对象
 @param controller  出现分享界面所在的ViewController
 @param delegate 实现摇一摇后，或者分享完成后的回调对象，如果不处理这些事件，可以设置为nil
 */
+(void)setShakeToShareWithTypes:(NSArray *)snsTypes
                      shareText:(NSString *)shareText
                   screenShoter:(UMSocialScreenShoter *)screenShoter
               inViewController:(UIViewController *)controller
                       delegate:(id<UMSocialShakeDelegate>)delegate;

/*
 解除注册响应摇一摇事件
 
 */
+(void)unShakeToSns;
@end


/*
 分享内容编辑视图页面，需要传入分享平台数组，和所在的viewController对象
 
 */
@interface UMSocialShareEditView : UIView

/**
 实现摇一摇回调协议的对象
 */
@property (nonatomic, assign) id<UMSocialShakeDelegate> shakeDelegate;

/**
 分享到的平台数组
 */
@property (nonatomic, retain) NSArray *snsNames;

/**
 分享页面所在的viewController对象
 */
@property (nonatomic, assign) UIViewController *controller;

/**
 编辑分享内容页面的初始化方法
 
 @param snsTypes 显示的可分享的平台数组
 @param controller 所在的ViewController对象
 
 */
-(id)initWithSnsTypes:(NSArray *)snsTypes controller:(UIViewController *)controller;

@end

