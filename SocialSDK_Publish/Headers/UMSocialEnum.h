//
//  UMSocialEnum.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-25.
//
//

#import <Foundation/Foundation.h>

/**
 新浪微博
 */
extern NSString *const UMShareToSina;

/**
 腾讯微博
 */
extern NSString *const UMShareToTencent;

/**
 人人网
 */
extern NSString *const UMShareToRenren;

/**
 豆瓣
 */
extern NSString *const UMShareToDouban;

/**
 QQ空间
 */
extern NSString *const UMShareToQzone;

/**
 分享平台
 
 */
typedef enum {
    UMSocialSnsTypeNone = -1,
    UMSocialSnsTypeQzone = 10,
    UMSocialSnsTypeSina,                 //sina weibo
    UMSocialSnsTypeTenc,                 //tencent weibo
    UMSocialSnsTypeRenr,                 //renren
    UMSocialSnsTypeDouban,               //douban
    UMSocialSnsTypeCount,                //count the number of sns,now is 15
    UMSocialSnsTypeEmail,
    UMSocialSnsTypeSms
} UMSocialSnsType;

/**
 网络请求结果状态码
 
 */
typedef enum {
    UMSResponseCodeSuccess            = 200,
    UMSResponseCodeBaned              = 505,
    UMSResponseCodeShareRepeated      = 5016,
    UMSResponseCodeGetNoUidFromOauth  = 5020,
    UMSResponseCodeAccessTokenExpired = 5027,
    UMSResponseCodeNetworkError       = 5050
} UMSResponseCode;

/**
 网络请求类型
 
 */
typedef enum {
	UMSResponseAddComment = 0,
    UMSResponseAddLike,
    UMSResponseGetCommentList,
    UMSResponseGetSocialData,
    UMSResponseShareToSNS,
    UMSResponseShareToMutilSNS,
    UMSResponseBinding,
    UMSResponseUnBinding,
    UMSResponseUnOauth,
    UMSResponseOauth,
    UMSResponseGetAccount,
    UMSResponseGetSnsInfo,
    UMSResponseGetFriends,
    UMSResponseAddFollow
} UMSResponse;


/**
 此SDK中用到的一些枚举类型和常量字符串
 
 ## 分享平台类型 
 
    typedef enum {
    UMSocialSnsTypeNone = -1,
    UMSocialSnsTypeQzone = 10,           //QQ空间
    UMSocialSnsTypeSina ,                //新浪微博
    UMSocialSnsTypeTenc,                 //腾讯微博
    UMSocialSnsTypeRenr,                 //人人网
    UMSocialSnsTypeDouban,               //豆瓣    
    UMSocialSnsTypeCount,                //用于得到当前分享平台个数
    UMSocialSnsTypeEmail,                //邮件分享
    UMSocialSnsTypeSms                   //短信分享
    } UMSocialSnsType;
 
 
 
 ## 网络请求结果状态码
 
    typedef enum {
    UMSResponseCodeSuccess            = 200,        //成功
    UMSResponseCodeShareRepeated      = 5016,       //重复发送微博
    UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到uid
    UMSResponseCodeAccessTokenExpired = 5027,       //授权过期
    UMSResponseCodeNetworkError       = 5050        //网络错误
    } UMSResponseCode;
 
    这里列举的错误码是sdk会处理的错误码，更多的错误码请见集成文档的附录
 
 
 ## 网络请求返回类型 
 
    typedef enum {
    UMSResponseAddComment = 0,          //添加评论
    UMSResponseAddLike,                 //添加喜欢
    UMSResponseGetCommentList,          //得到评论列表
    UMSResponseGetSocialData,           //得到`UMSocialData`对象属性数据
    UMSResponseShareToSNS,              //分享到微博
    UMSResponseBinding,                 //绑定一个微博账号作为登录账号
    UMSResponseUnBinding,               //解除绑定的登录账号
    UMSResponseUnOauth,                 //解除一个微博账号的授权
    UMSResponseOauth,                   //授权一个微博账号
    UMSResponseGetAccount,              //请求微博账号信息
    UMSResponseGetSnsInfo,              //请求获取微博账号的详细信息
    UMSResponseGetFriends               //获取好友列表
    } UMSResponse;
  
 ## 常量字符串 
 
 主要用于代表不同的微博平台名，例如`UMShareToSina`定义为"sina"，避免开发者使用sdk时候写错
 
    NSString *const UMShareToSina;      //新浪微博
    NSString *const UMShareToTencent;   //腾讯微博
    NSString *const UMShareToRenren;    //人人网
    NSString *const UMShareToDouban;    //豆瓣
    NSString *const UMShareToQzone;     //QQ空间
 */

@interface UMSocialEnum : NSObject

@end
