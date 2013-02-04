//
//  UMSocialIconActionSheet.h
//  SocialSDK
//
//  Created by yeahugo on 13-1-11.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialEnum.h"

typedef void (^UMIconActionSheetButtonClickHandler)(UMSocialSnsType snsType);

/*
 自定义的类似iOS6.0中`UIActivityViewController`样式的列表，每个sns平台由对应图片和名称组成。
 */
@interface UMSocialIconActionSheet : UIView
{
    UMIconActionSheetButtonClickHandler _actionSheetHandler;
}

/**
 处理点击每一项之后的处理器对象
 
 */
@property(nonatomic,copy) UMIconActionSheetButtonClickHandler actionSheetHandler;

/**
 初始化方法
 
 @param items 显示每个小格对象数组，数组中的对象要求是`UMSocialSnsPlatform`类型
 @param handler 处理点击之后的block处理对象
 */
-(id)initWithItems:(NSArray *)items withButtonHandler:(void (^)(UMSocialSnsType snsType))handler;

/**
 讲自己自下往上弹出来
 
 @param showView 在此父UIView自下往上弹出来的
 */
-(void)showInView:(UIView *)showView;

/**
 将自己移除
 
*/
-(void)dismiss;
@end
