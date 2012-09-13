//
//  UMSocialDelegate.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-6.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UMShareToTypeNone = -1,
    UMShareToTypeSina = 0,             //sina weibo
    UMShareToTypeTenc,                 //tencent weibo
    UMShareToTypeRenr,                 //renren
    UMShareToTypeDouban,               //douban
    UMShareToTypeCount,                //count the number of sns,now is 4
    UMShareToTypeMail = 10,
    UMShareToTypeSMS
} UMShareToType;

typedef enum{
    UMViewControllerCommentList,        //评论列表
    UMViewControllerCommentEdit,        //评论编辑页
    UMViewControllerShareList,          //分享列表页，包含sdk支持的所有sns平台
    UMViewControllerShareEdit,          //分享编辑页
    UMViewControllerAccount,            //分享账号设置页面
    UMViewControllerOauth,              //oath授权页面
    UMViewControllerLogin               //登录页面，登录的可选平台为sdk所支持的sns平台
}UMViewControllerType;

@protocol UMSocialDelegate <NSObject>
@optional

//在`response`参数中`data`字段为返回数据，如果`st`为200，代表成功，`st`不为200的话会在`msg`字段表明错误原因
//授权完成
-(void)didFinishOauthToSnsWithResponse:(NSDictionary *)response;

//登录完成
-(void)didFinishLoginWithResponse:(NSDictionary *)response;

//调用requestSocialInfomation之后的回调，得到social的详细信息
-(void)didFinishGetBarInfoWithResponse:(NSDictionary *)response;

//分享到sns平台完成
-(void)didFinishShareToSnsWithResponse:(NSDictionary *)response;

//添加评论完成
-(void)didFinishAddCommentWithResponse:(NSDictionary *)response;

//添加喜欢或者取消喜欢完成
-(void)didFinishAddLikeWithResponse:(NSDictionary *)response;

//获取评论列表完成
-(void)didFinishRequestCommentListWithResponse:(NSDictionary *)response;
@end