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
    NSMutableArray *_commentEntityArray;
}

@property (nonatomic, retain) NSMutableArray *commentEntityArray;

/**
 返回一个以[UMSocialData defaultData]来做初始化参数的`UMSocialControllerServiceComment`对象
 
 @return `UMSocialControllerServiceComment`的默认初始化对象
 */
+(UMSocialControllerServiceComment *)defaultControllerService;

/**
 评论列表页面，评论列表页面包括各评论详情、评论编辑
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialCommentListController;

@end
