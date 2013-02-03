//
//  UMSocialControllerServiceComment.h
//  SocialSDK
//
//  Created by yeahugo on 12-12-7.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"

@class UMSCommentEntity;
@interface UMSocialControllerServiceComment : UMSocialControllerService
{
    NSMutableArray *_commentEntityArray;
    UMSCommentEntity  *_selectComment;
//    NSMutableDictionary * _commentShareAccountDic;
}

@property (nonatomic, retain) NSMutableArray *commentEntityArray;

@property (nonatomic, retain) UMSCommentEntity *selectComment;

@property (nonatomic ,retain) UIColor *defaultColor;
//@property (nonatomic, retain) NSMutableDictionary * commentShareAccountDic;

/**
 评论列表页面，评论列表页面包括各评论详情、评论编辑
 
 @return `UINavigationController`对象
 */
- (UINavigationController *)getSocialCommentListController;

@end
