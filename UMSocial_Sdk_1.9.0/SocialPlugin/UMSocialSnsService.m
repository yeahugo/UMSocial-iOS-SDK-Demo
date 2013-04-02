//
//  UMSocialSnsService.m
//  SocialSDK
//
//  Created by yeahugo on 13-1-8.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsService.h"
#import "UMSocialAccountEntity.h"
#import "UMSocialAccountManager.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialIconActionSheet.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "WXApi.h"

#ifdef __IPHONE_6_0
#import <Social/Social.h>
#endif

#define SLServiceTypeFacebook @"com.apple.social.facebook"
#define SLServiceTypeTwitter @"com.apple.social.twitter"

@implementation UMSocialSnsService

#if __UMSocial__Support__SSO
@synthesize sinaWeibo = _sinaWeibo;
#endif
@synthesize completion = _completion;
@synthesize socialControllerService = _socialControllerService;
-(void)dealloc
{
    SAFE_ARC_RELEASE(_socialControllerService);
    _socialControllerService = nil;
    SAFE_ARC_RELEASE(_snsArray);
    SAFE_ARC_SUPER_DEALLOC();
}

+ (UMSocialSnsService *)sharedInstance
{
	static UMSocialSnsService *_instance = nil;
    
	@synchronized(self) {
		if (_instance == nil) {            
			_instance = [[self alloc] init];
		}
	}
    
	return _instance;
}

#if __UMSocial__Support__SSO
+(BOOL)handleOpenURL:(NSURL *)url
{
    if ([url.description hasPrefix:@"sinaweibosso"]) {
        return [[UMSocialSnsService sharedInstance].sinaWeibo handleOpenURL:url];
    }
    else if([url.description hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:[UMSocialSnsService sharedInstance]];
    }    
}


+(void)handleOauthWithSnsName:(NSString *)snsName controller:(UIViewController *)controller completion:(void (^)(void))completion
{
    [UMSocialSnsService sharedInstance].completion = completion;
    if ([snsName isEqualToString:UMShareToSina] && ![UMSocialAccountManager isOauthWithPlatform:snsName]) {
        [[UMSocialSnsService sharedInstance].sinaWeibo logIn];
        [UMSocialSnsService sharedInstance].sinaWeibo.delegate = [UMSocialSnsService sharedInstance];
    }
    else{
        completion();
    }
}

-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    self.completion();
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    UMLog(@"account is %@",[UMSocialAccountManager socialAccountDictionary]);
    UMSocialAccountEntity *snsAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToSina];
    snsAccount.usid = sinaweibo.userID;
    snsAccount.accessToken = sinaweibo.accessToken;
    [UMSocialAccountManager setSnsAccount:snsAccount];
    SAFE_ARC_RELEASE(snsAccount);
    
    UMSocialCustomAccount *customAccount = [[UMSocialCustomAccount alloc] initWithUserName:sinaweibo.userID];
    customAccount.platformName = UMShareToSina;
    customAccount.usid = sinaweibo.userID;
    customAccount.customData = [NSDictionary dictionaryWithObject:sinaweibo.accessToken forKey:@"accessToken"];
    [UMSocialAccountManager addCustomAccount:customAccount completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess && self.completion!= nil) {
            self.completion();
        }
    }];
    SAFE_ARC_RELEASE(customAccount);
    
    UMLog(@"uid is %@ token is %@",sinaweibo.userID,sinaweibo.accessToken);
}

#else

+(BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[UMSocialSnsService sharedInstance]];
}

#endif

-(void)willCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    self.completion();
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req type is %d",resp.type);
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString * message = nil;
        message = [NSString stringWithFormat:@"%d",resp.errCode];
        if (resp.errCode == WXSuccess) {
            message = @"成功";
        }
        else if (resp.errCode == WXErrCodeSentFail) {
            message = @"发送失败";
        }
        else if (resp.errCode == WXErrCodeAuthDeny)
        {
            message = @"授权失败";
        }
        else if (resp.errCode == WXErrCodeUnsupport){
            message = @"不支持";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享结果" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    }
}


-(id)init
{
    if (self = [super init]) {
#if __UMSocial__Support__SSO
        _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        _sinaWeibo.delegate = self;
#endif
        _socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:[UMSocialData defaultData]];
        
        UMSocialSnsPlatform *wechatPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToWechat];
        wechatPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_wechart_icon";
        wechatPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_wechart_on.png";
        wechatPlatform.displayName = @"微信";
        wechatPlatform.loginName = @"微信账号";
        wechatPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到微信" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给好友",@"分享到朋友圈",nil];
            if (presentingController.tabBarController != nil) {
                [actionSheet showInView:presentingController.tabBarController.tabBar];
            }
            else{
                [actionSheet showInView:presentingController.view];
            }
            _socialControllerService = socialControllerService;
            SAFE_ARC_RELEASE(actionSheet);
        };
        
#ifdef __IPHONE_6_0
        UMSocialSnsPlatform *facebookPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToFacebook];
        facebookPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_facebook_icon";
        facebookPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_facebook_on.png";
        facebookPlatform.displayName = @"Facebook";
        facebookPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            if([NSClassFromString(@"SLComposeViewController") class] != nil)
            {
                if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeFacebook]) {
                    SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeFacebook];
                    if (socialControllerService != nil) {
                        [slcomposeViewController setInitialText:socialControllerService.socialData.shareText];
                        [slcomposeViewController addImage:socialControllerService.socialData.shareImage];
                        slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
                            if (result == SLComposeViewControllerResultDone) {
                                [socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToFacebook] content:socialControllerService.socialData.shareText image:socialControllerService.socialData.shareImage location:nil urlResource:nil completion:nil];
                                if ([socialControllerService.socialUIDelegate respondsToSelector:@selector(didFinishGetUMSocialDataInViewController:)])
                                {
                                    UMSocialResponseEntity *response = [[UMSocialResponseEntity alloc] init];
                                    response.responseCode = UMSResponseCodeSuccess;
                                    response.responseType = UMSViewControllerShareEdit;
                                    [socialControllerService.socialUIDelegate didFinishGetUMSocialDataInViewController:response];
                                    SAFE_ARC_RELEASE(response);
                                }
                            }
                            [presentingController dismissModalViewControllerAnimated:YES];
                        };
                        [presentingController presentModalViewController:slcomposeViewController animated:YES];
                    }
                    
                }
                else{
                    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Facebook账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [loginAlert show];
                    SAFE_ARC_RELEASE(loginAlert);
                }
            }
            else{
                UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Facebook的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [osAlert show];
                SAFE_ARC_RELEASE(osAlert);
            }
        };
        
        UMSocialSnsPlatform *twitterPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToTwitter];
        twitterPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_twitter_icon";
        twitterPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_twitter_on.png";
        twitterPlatform.displayName = @"Twitter";       
        twitterPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            
            if([NSClassFromString(@"SLComposeViewController") class] != nil){
                if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeTwitter]) {
                    SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeTwitter];
                    if (socialControllerService != nil) {
                        slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
                            if (result == SLComposeViewControllerResultDone) {
                                if ([socialControllerService.socialUIDelegate respondsToSelector:@selector(didFinishGetUMSocialDataInViewController:)])
                                {
                                    UMSocialResponseEntity *response = [[UMSocialResponseEntity alloc] init];
                                    response.responseCode = UMSResponseCodeSuccess;
                                    response.responseType = UMSViewControllerShareEdit;
                                    [socialControllerService.socialUIDelegate didFinishGetUMSocialDataInViewController:response];
                                    SAFE_ARC_RELEASE(response);
                                }
                            }
                            [presentingController dismissModalViewControllerAnimated:YES];
                        };
                        
                        [socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToTwitter] content:socialControllerService.socialData.shareText image:socialControllerService.socialData.shareImage location:nil urlResource:nil completion:nil];
                        
                        [slcomposeViewController setInitialText:socialControllerService.socialData.shareText];
                        [slcomposeViewController addImage:socialControllerService.socialData.shareImage];
                        
                        [presentingController presentModalViewController:slcomposeViewController animated:YES];
                    }
                }
                else{
                    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Twitter账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [loginAlert show];
                    SAFE_ARC_RELEASE(loginAlert);
                }
            }
            else{
                UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Twitter的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [osAlert show];
                SAFE_ARC_RELEASE(osAlert);
            }
        };
        
        [UMSocialConfig addSocialSnsPlatform:[NSArray arrayWithObjects:wechatPlatform,facebookPlatform,twitterPlatform,nil]];
#else
        [UMSocialConfig addSocialSnsPlatform:[NSArray arrayWithObjects:wechatPlatform,nil]];        
#endif

    }
    return self;
}


+(void)presentSnsController:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsNames:(NSArray *)snsNames delegate:(id <UMSocialUIDelegate>)delegate
{
    [[UMSocialSnsService sharedInstance] presentSnsController:controller appKey:appKey shareText:shareText shareImage:shareImage shareToSnsStrings:snsNames delegate:delegate];
}

+(void)presentSnsIconSheetView:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsNames:(NSArray *)snsNames delegate:(id <UMSocialUIDelegate>)delegate
{
    [[UMSocialSnsService sharedInstance] showSnsIconSheetView:controller appKey:appKey shareText:shareText shareImage:shareImage shareToSnsStrings:snsNames delegate:delegate];
}

-(void)setSocialDataWithController:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage delegate:(id <UMSocialUIDelegate>)delegate
{
    _presentingViewController = controller;
    if (appKey != nil) {
        [UMSocialData setAppKey:appKey];        
    }
    UMSocialData *socialData = [UMSocialData defaultData];
    socialData.shareText = shareText;
    socialData.shareImage = shareImage;
    _socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    _socialControllerService.socialUIDelegate = delegate;
}

-(void)presentSnsController:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsStrings:(NSArray *)snsStrings delegate:(id <UMSocialUIDelegate>)delegate
{
    [self setSocialDataWithController:controller appKey:appKey shareText:shareText shareImage:shareImage delegate:delegate];
    UINavigationController *snsListController = [_socialControllerService getSocialShareListController];
    if (snsStrings != nil) {
        [snsListController.visibleViewController performSelector:@selector(setAllSnsArray:) withObject:snsStrings];        
    }
    [_presentingViewController presentModalViewController:snsListController animated:YES];
}

-(void)showSnsIconSheetView:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsStrings:(NSArray *)snsStrings delegate:(id <UMSocialUIDelegate>)delegate
{
    [self setSocialDataWithController:controller appKey:appKey shareText:shareText shareImage:shareImage delegate:delegate];

    UMSocialIconActionSheet *snsIconSheet = (UMSocialIconActionSheet *)[_socialControllerService getSocialIconActionSheetInController:controller];
    if (snsStrings != nil) {
        [snsIconSheet setSnsNames:snsStrings];        
    }
    UIViewController *presentingViewController = nil;
    @try {
        presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    @catch (NSException *exception) {
        presentingViewController = controller;
    }
    @finally {
        
    }

    [snsIconSheet showInView:presentingViewController.view];
}

#ifdef __IPHONE_6_0
-(void)didSelectSLComposeViewController:(NSString *)snsName showController:(UIViewController *)showViewController withSocialData:(UMSocialData *)socialData
{
    NSString *slServiceType = nil;
    NSString *slName = nil;
    if ([snsName isEqualToString:UMShareToFacebook]) {
        slServiceType = SLServiceTypeFacebook;
        slName = @"Facebook";
    }
    else if ([snsName isEqualToString:UMShareToTwitter]){
        slServiceType = SLServiceTypeTwitter;
        slName = @"Twitter";
    }

    if([NSClassFromString(@"SLComposeViewController") class] != nil)
    {
        if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:slServiceType]) {
            SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:slServiceType];
            if (socialData != nil) {
                [slcomposeViewController setInitialText:socialData.shareText];
                [slcomposeViewController addImage:socialData.shareImage];                
            }
            [showViewController presentModalViewController:slcomposeViewController animated:YES];
        }
        else{
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的%@账号尚未登录，请在系统设置中登录",slName] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [loginAlert show];
            SAFE_ARC_RELEASE(loginAlert);
        }
    }
    else{
        UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"您的设备系统不支持分享到%@的功能",slName] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [osAlert show];
        SAFE_ARC_RELEASE(osAlert);
    }
}
#endif

- (UIImage*)imageByScalingAndCroppingFromImage:(UIImage *)sourceImage size:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        if (_socialControllerService.currentNavigationController != nil) {
            [_socialControllerService performSelector:@selector(close)];
        }
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = _socialControllerService.socialData.shareText;
        
        req.bText = YES;
        
        if (_socialControllerService.socialData.extConfig != nil) {
            if (_socialControllerService.socialData.extConfig.wxMessageType == UMSocialWXMessageTypeApp) {
                
                WXAppExtendObject *ext = [WXAppExtendObject object];
                int buffer_size = 10;
                Byte *pBuffer = (Byte *)malloc(buffer_size);
                memset(pBuffer, 0, buffer_size);
                NSData *data = [NSData dataWithBytes:pBuffer length:buffer_size];
                free(pBuffer);
                
                ext.fileData = data;
                
                WXMediaMessage *message = [WXMediaMessage message];
                NSString *shareText = _socialControllerService.socialData.shareText;
                NSString *title = [NSString stringWithFormat:@"%@……",[shareText substringToIndex:10]];
                
                if (_socialControllerService.socialData.extConfig != nil) {
                    if(_socialControllerService.socialData.extConfig.title != nil){
                        title = _socialControllerService.socialData.extConfig.title;
                    }
                    if (_socialControllerService.socialData.extConfig.appUrl != nil) {
                        ext.url = _socialControllerService.socialData.extConfig.appUrl;
                    }
                }
                message.title = title;
                
                message.description = _socialControllerService.socialData.shareText;
                UIImage *thumbImage = _socialControllerService.socialData.shareImage;
                thumbImage = [self imageByScalingAndCroppingFromImage:thumbImage size:CGSizeMake(100, 100)];
                [message setThumbImage:thumbImage];
                message.mediaObject = ext;
                
                req.message = message;
                req.bText = NO;
            }
            else if (_socialControllerService.socialData.extConfig.wxMessageType == UMSocialWXMessageTypeImage){
                WXImageObject *imageObject = [WXImageObject object];
                [imageObject setImageData:UIImagePNGRepresentation(_socialControllerService.socialData.shareImage)];
                WXMediaMessage *message = [WXMediaMessage message];
                [message setThumbImage:[self imageByScalingAndCroppingFromImage:_socialControllerService.socialData.shareImage size:CGSizeMake(100, 100)]];
                message.mediaObject = imageObject;

                req.message = message;
                req.bText = NO;
            }
        }
        
        if (buttonIndex == 0) {
            req.scene = WXSceneSession;
            [_socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToWechatSession] content:req.text image:nil location:nil urlResource:nil completion:nil];
        }
        if (buttonIndex == 1) {
            req.scene = WXSceneTimeline;
            [_socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToWechatTimeline] content:req.text image:nil location:nil urlResource:nil completion:nil];
        }
        [WXApi sendReq:req];
        SAFE_ARC_RELEASE(req);
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
        SAFE_ARC_RELEASE(alertView);
    }
}

@end