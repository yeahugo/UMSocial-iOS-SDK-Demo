//
//  UMSocialControllerServiceComment.h
//  SocialSDK
//
//  Created by yeahugo on 12-12-7.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"

@interface UMSocialControllerServiceComment : UMSocialControllerService
{
    BOOL _commentNeedLogin;
}

/**
 弹出评论列表页面，设置是否需要授权一个微博平台并且绑定作为使用评论的登录账号，默认需要。
 */
@property (nonatomic, assign) BOOL commentNeedLogin;

/**
 评论列表页面，评论列表页面包括各评论详情、评论编辑
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialCommentListController;

@end
