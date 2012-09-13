//
//  UMSocialService.h
//  UMSocialSDK
//
//  Created by iOS Umeng on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialDelegate.h"
#import "UMSocialConfigDelegate.h"

@class UMSocailBarView;
@class CLLocation;

@interface UMSocialService : NSObject
{
    UMSocailBarView *_socialBar;
    NSString   *_descriptor;
}

@property (nonatomic, readonly) UIView *socialBar;          //SocialBar视图，继承自UIView，可以自己改变位置
@property (copy) NSString *descriptor;                      //每个UMSocialService对象的标识，应用内保证每个对象的descriptor唯一
@property (copy) NSString * shareText;                      //分享的默认内容
@property (copy) NSString * commentText;                    //用于用户在评论并分享的时候，该字段内容会自动添加到评论的后面，分享到各个分享平台
@property (retain) UIImage * shareImage;                    //分享的图片
@property (retain) UIImage * commentImage;                  //用于用户在评论并分享的时候，该字段内容会自动添加到评论中的图片，分享到各个分享平台

@property (nonatomic, readonly) int likeNumber;             //喜欢个数  
@property (nonatomic, readonly) int shareNumber;            //分享个数
@property (nonatomic, readonly) int commentNumber;          //评论个数
@property (nonatomic, readonly) BOOL isLike;                //是否已经喜欢

/*获取每个已经授权sns平台和已经登录平台的用户数据，每个NSDictionary内是一个我们定义的UMSnsAccountEntity对象，你可以获取到对象的属性，对象的属性定义为
 @property (nonatomic, copy) NSString *platformName;
 @property (nonatomic, copy) NSString *userName;
 @property (nonatomic, copy) NSString *usid;
 @property (nonatomic, copy) NSString *iconURL;
 @property (nonatomic, copy) NSString *accessToken;
 @property (nonatomic, copy) NSString *profileURL;
 */
@property (nonatomic, readonly) NSDictionary *umAccount;    



/** setAppKey: 
 设置SDK使用的appKey,此appKey从友盟网站获取，使用此SDK只需要对appKey进行一次设定即可
 @param appKey 从友盟网站获取到的appKey
 */
+ (void)setAppKey:(NSString *)appKey;

/** openLog: 
 设置是否输出调试信息，默认不输出
 @param isLog 设置是否输出log信息
 */
+ (void)openLog:(BOOL)isLog;


/** setSocialConfigDelegate: 
 设置实现<UMSocialConfigDelegate>的对象，此对象进行一些Social参数的设置
 @param id <UMSocialConfigDelegate> 实现此协议的对象
 */
+ (void)setSocialConfigDelegate:(id <UMSocialConfigDelegate>)delegate;


/** setUMSocialDelegate
 设置UMSocialDelegate，此对象获得Social进行动作之后的一些回调
 @prarm id <UMSocialDelegate> 实现此协议的对象
 */
- (void)setUMSocialDelegate:(id <UMSocialDelegate>)delegate;


/** initWithDescriptor: 
 初始化UMSocialService
 @param descriptor 对分享资源的唯一性的标识，你可以对不同的页面、图片进行评论，在应用中保证不同的资源descirptor唯一。
 @return UMSocialService对象
 */
- (id)initWithDescriptor:(NSString *)descriptor;


/** requestSocialInfomation: 
 获取社会化组件的数据，包括评论数、分享数、喜欢数等，一般用在每次重新出现socialBar时候获取数据，同时会自动刷新对应的数字
 */
- (void)requestSocialInfomation;


/* presentSocialViewController
 弹出指定viewController，评论列表或者评论编辑页，或者分享列表页，分享列表页，个人账户页面等等
 @param UMViewControllerType 弹出页面类型
 @param UMShareToType   弹出分享编辑页，或者授权页面的sns平台类型
 */
- (void)presentSocialViewController:(UMViewControllerType)viewControllerType;
- (void)presentSocialViewController:(UMViewControllerType)viewControllerType withSnsType:(UMShareToType)shareToType;


/* getSocialViewController
 获得指定viewController，评论列表或者评论编辑页，或者分享列表页，分享列表页，个人账户页面等等
 @param UMViewControllerType 获得的页面类型
 @param UMShareToType   获得的分享编辑页，或者授权页面的sns平台类型
 */
- (UIViewController *)getSocialViewController:(UMViewControllerType)viewControllerType;
- (UIViewController *)getSocialViewController:(UMViewControllerType)viewControllerType withSnsType:(UMShareToType)shareToType;


/** postSNSWithType
 直接发送内容到指定平台 
*/
- (void)postSNSWithType:(UMShareToType)umShareType content:(NSString *)content image:(UIImage *)image;


/** postCommentWithContent
 直接发送评论 
 */
- (void)postCommentWithContent:(NSString *)content image:(UIImage *)image location:(CLLocation *)location;


/** requestCommentList
 请求获取评论列表，最近的排在前面，每次返回10条
 @param lastCommentTime 上一条评论的时间戳，获取最新的评论设为-1,再次获取时可以设置为上次最后一条的dt 
 */
- (void)requestCommentList:(NSInteger)lastCommentTime;

/* addOrMinusLikeNumber
 如果没有喜欢过的话，喜欢状态变成喜欢，喜欢数量加1，如果喜欢过的话，喜欢状态变成不喜欢，数量减1
 */
- (void)addOrMinusLikeNumber;
@end



