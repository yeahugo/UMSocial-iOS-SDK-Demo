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


-(id)initWithItems:(NSArray *)items withButtonHandler:(void (^)(UMSocialSnsType snsType))handler;

-(void)showInView:(UIView *)showView;

-(void)dismiss;
@end
