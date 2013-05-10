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
@synthesize authorization = _authorization;
//@synthesize socialControllerService = _socialControllerService;
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
+(BOOL)handleOpenURL:(NSURL *)url wxApiDelegate:(id<WXApiDelegate>)wxApiDelegate
{
    if ([url.description hasPrefix:@"sinaweibosso"]) {
        return [[UMSocialSnsService sharedInstance].sinaWeibo handleOpenURL:url];
    }
    else if([url.description hasPrefix:@"wx"]){
        id delegate = wxApiDelegate;
        if (delegate == nil) {
            delegate = [UMSocialSnsService sharedInstance];
        }
        return [WXApi handleOpenURL:url delegate:delegate];
    }
    return NO;
}


-(void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    self.authorization();
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    if (self.completion != nil) {
        UMSocialResponseEntity *response = [[UMSocialResponseEntity alloc] init];
        response.responseType = UMSResponseOauth;
        response.responseCode = UMSResponseCodeCancel;
        response.data = [NSDictionary dictionaryWithObject:@"" forKey:UMShareToSina];
        self.completion(response);
        SAFE_ARC_RELEASE(response);
    }
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    UMSocialAccountEntity *sinaAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToSina];
    sinaAccount.usid = sinaweibo.userID;
    sinaAccount.accessToken = sinaweibo.accessToken;
    
    [UMSocialAccountManager postSnsAccount:sinaAccount completion:^(UMSocialResponseEntity * response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [UMSocialAccountManager setSnsAccount:sinaAccount];
        }
        if (self.completion!= nil) {
            response.responseType = UMSResponseOauth;
            response.viewControllerType = UMSViewControllerOauth;
            response.data = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:sinaAccount.usid,@"usid",sinaAccount.accessToken,@"accessToken",nil] forKey:UMShareToSina];
            self.completion(response);
        }
    }];
    SAFE_ARC_RELEASE(sinaAccount);
}

-(void)resetSinaWeibo
{
    self.sinaWeibo.userID = nil;
}

#else

+(BOOL)handleOpenURL:(NSURL *)url wxApiDelegate:(id<WXApiDelegate>)wxApiDelegate
{
    if([url.description hasPrefix:@"wx"]){
        id delegate = wxApiDelegate;
        if (delegate == nil) {
            delegate = [UMSocialSnsService sharedInstance];
        }
        return [WXApi handleOpenURL:url delegate:delegate];
    }
    return NO;
}


#endif

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString * message = nil;
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
        
        if (message != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享结果" message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            SAFE_ARC_RELEASE(alertView);
        }
    }
}


-(id)init
{
    if (self = [super init]) {
#if __UMSocial__Support__SSO
        _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:@"appkey" appSecret:@"appsecret" appRedirectURI:kAppRedirectURI andDelegate:self];
        _sinaWeibo.delegate = self;
#endif
        _socialControllerService = nil;
        
        UMSocialSnsPlatform *wechatPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToWechat];
        wechatPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_wechart_icon";
        wechatPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_wechart_on.png";
        wechatPlatform.displayName = @"微信";
        wechatPlatform.loginName = @"微信账号";
        wechatPlatform.shareToType = UMSocialSnsTypeSms + 1;
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

        UMSocialSnsPlatform *facebookPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToFacebook];
        facebookPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_facebook_icon";
        facebookPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_facebook_on.png";
        facebookPlatform.displayName = @"Facebook";
        facebookPlatform.shareToType = UMSocialSnsTypeSms + 2;

        facebookPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            if([NSClassFromString(@"SLComposeViewController") class] != nil)
            {
                #ifdef __IPHONE_6_0
                if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeFacebook]) {
                    SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeFacebook];
                    if (socialControllerService != nil) {
                        [slcomposeViewController setInitialText:socialControllerService.socialData.shareText];
                        [slcomposeViewController addImage:socialControllerService.socialData.shareImage];
                        slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
                            if (result == SLComposeViewControllerResultDone) {
                                [socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToFacebook] content:socialControllerService.socialData.shareText image:socialControllerService.socialData.shareImage location:nil urlResource:nil completion:^(UMSocialResponseEntity *response){
                                    if ([socialControllerService.socialUIDelegate respondsToSelector:@selector(didFinishGetUMSocialDataInViewController:)])
                                    {
                                        response.viewControllerType = UMSViewControllerShareEdit;
                                        [socialControllerService.socialUIDelegate didFinishGetUMSocialDataInViewController:response];
                                    }
                                }];

                            }
                            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                            [presentingController dismissModalViewControllerAnimated:YES];
                            #pragma GCC diagnostic warning "-Wdeprecated-declarations"
                        };
                        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                        [presentingController presentModalViewController:slcomposeViewController animated:YES];
                        #pragma GCC diagnostic warning "-Wdeprecated-declarations"
                    }
                }
                else{
                    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Facebook账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [loginAlert show];
                    SAFE_ARC_RELEASE(loginAlert);
                }
                #endif
            }
            else{
                UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"系统不支持此功能" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Facebook的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [osAlert show];
                SAFE_ARC_RELEASE(osAlert);
            }
        };

        
        UMSocialSnsPlatform *twitterPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToTwitter];
        twitterPlatform.bigImageName = @"UMSocialSDKResources.bundle/UMS_twitter_icon";
        twitterPlatform.smallImageName = @"UMSocialSDKResources.bundle/UMS_twitter_on.png";
        twitterPlatform.displayName = @"Twitter";
        twitterPlatform.shareToType = UMSocialSnsTypeSms + 3;
        twitterPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            if([NSClassFromString(@"SLComposeViewController") class] != nil){
                #ifdef __IPHONE_6_0
                if ([NSClassFromString(@"SLComposeViewController") isAvailableForServiceType:SLServiceTypeTwitter]) {
                    SLComposeViewController *slcomposeViewController =  [NSClassFromString(@"SLComposeViewController") composeViewControllerForServiceType:SLServiceTypeTwitter];
                    if (socialControllerService != nil) {
                        [slcomposeViewController setInitialText:socialControllerService.socialData.shareText];
                        [slcomposeViewController addImage:socialControllerService.socialData.shareImage];

                        slcomposeViewController.completionHandler = ^(SLComposeViewControllerResult result){
                            if (result == SLComposeViewControllerResultDone) {
                                [socialControllerService.socialDataService postSNSWithTypes:[NSArray arrayWithObject:UMShareToTwitter] content:socialControllerService.socialData.shareText image:socialControllerService.socialData.shareImage location:nil urlResource:nil completion:^(UMSocialResponseEntity *response){
                                    if ([socialControllerService.socialUIDelegate respondsToSelector:@selector(didFinishGetUMSocialDataInViewController:)])
                                    {
                                        response.viewControllerType = UMSViewControllerShareEdit;
                                        [socialControllerService.socialUIDelegate didFinishGetUMSocialDataInViewController:response];
                                    }
                                }];
                                
                            }
                            #pragma GCC diagnostic ignored "-Wdeprecated-declarations" 
                            [presentingController dismissModalViewControllerAnimated:YES];
                            #pragma GCC diagnostic warning "-Wdeprecated-declarations"
                        };
                         #pragma GCC diagnostic ignored "-Wdeprecated-declarations"                   
                        [presentingController presentModalViewController:slcomposeViewController animated:YES];
                        #pragma GCC diagnostic warning "-Wdeprecated-declarations"
                    }
                }
                else{
                    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"账号未登录" message:[NSString stringWithFormat:@"您的Twitter账号尚未登录，请在系统设置中登录"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [loginAlert show];
                    SAFE_ARC_RELEASE(loginAlert);
                }
                #endif
            }
            else{
                UIAlertView *osAlert = [[UIAlertView alloc] initWithTitle:@"系统不支持此功能" message:[NSString stringWithFormat:@"您的设备系统不支持分享到Twitter的功能"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [osAlert show];
                SAFE_ARC_RELEASE(osAlert);
            }
        };

        [UMSocialConfig addSocialSnsPlatform:[NSArray arrayWithObjects:wechatPlatform,facebookPlatform,twitterPlatform,nil]];
        SAFE_ARC_RELEASE(wechatPlatform);
        SAFE_ARC_RELEASE(facebookPlatform);
        SAFE_ARC_RELEASE(twitterPlatform);
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
    if (appKey != nil && [[UMSocialData appKey] isEqualToString:@""]) {
        [UMSocialData setAppKey:appKey];        
    }
    if (_socialControllerService == nil) {
        _socialControllerService = [[UMSocialControllerService alloc] init];
    }

    _socialControllerService.socialData.shareText = shareText;
    _socialControllerService.socialData.shareImage = shareImage;
    _socialControllerService.socialUIDelegate = delegate;
}

-(void)presentSnsController:(UIViewController *)controller appKey:(NSString *)appKey shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareToSnsStrings:(NSArray *)snsStrings delegate:(id <UMSocialUIDelegate>)delegate
{
    [self setSocialDataWithController:controller appKey:appKey shareText:shareText shareImage:shareImage delegate:delegate];
    UINavigationController *snsListController = [_socialControllerService getSocialShareListController];
    if (snsStrings != nil) {
        [snsListController.visibleViewController performSelector:@selector(setAllSnsArray:) withObject:snsStrings];        
    }
    #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [_presentingViewController presentModalViewController:snsListController animated:YES];
    #pragma GCC diagnostic warning "-Wdeprecated-declarations"
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
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [showViewController presentModalViewController:slcomposeViewController animated:YES];
            #pragma GCC diagnostic warning "-Wdeprecated-declarations"
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
        
        req.bText = YES;
        
        WXMediaMessage *message = [WXMediaMessage message];
        NSString *shareText = nil;
        if (_socialControllerService.socialData.extConfig.wxDescription != nil) {
            shareText = _socialControllerService.socialData.extConfig.wxDescription;
        }
        else{
            shareText = _socialControllerService.socialData.shareText;
        }
        req.text = shareText;
        
        NSInteger length = shareText.length > 10 ? 10:shareText.length;
        NSString *title = [NSString stringWithFormat:@"%@……",[shareText substringToIndex:length]];
        
        message.title = title;
        
        message.description = shareText;

        UIImage *thumbImage = _socialControllerService.socialData.shareImage;
        if (thumbImage != nil) {
            UIImage *scaleImage = [self imageByScalingAndCroppingFromImage:thumbImage size:CGSizeMake(100, 100)];
            [message setThumbImage:scaleImage];
        }
        else{
            [message setThumbImage:[UIImage imageNamed:@"icon"]];
        }
        
        if (_socialControllerService.socialData.extConfig != nil) {
            if(_socialControllerService.socialData.extConfig.title != nil){
                title = _socialControllerService.socialData.extConfig.title;
                message.title = title;
            }
            
            if (_socialControllerService.socialData.extConfig.wxMessageType == UMSocialWXMessageTypeApp) {
                
                WXAppExtendObject *ext = [WXAppExtendObject object];
                if (_socialControllerService.socialData.extConfig.appUrl != nil) {
                    ext.url = _socialControllerService.socialData.extConfig.appUrl;
                }
                else if(buttonIndex == 1){ //如果分享应用类型到朋友圈，必须带url，否则分享失败
                    ext.url = @"http://www.umeng.com";
                }
                
                int buffer_size = 10;
                Byte *pBuffer = (Byte *)malloc(buffer_size);
                memset(pBuffer, 0, buffer_size);
                NSData *data = [NSData dataWithBytes:pBuffer length:buffer_size];
                free(pBuffer);
                ext.fileData = data;
                
                message.mediaObject = ext;
                req.message = message;
                req.bText = NO;
            }
            else if (_socialControllerService.socialData.extConfig.wxMessageType == UMSocialWXMessageTypeImage){
                WXImageObject *imageObject = [WXImageObject object];
                [imageObject setImageData:UIImageJPEGRepresentation(_socialControllerService.socialData.shareImage, 0.9)];
                message.mediaObject = imageObject;

                req.message = message;
                req.bText = NO;
            }
            else if(_socialControllerService.socialData.extConfig.wxMessageType == UMSocialWXMessageTypeOther){
                if (_socialControllerService.socialData.extConfig.wxMediaObject != nil) {
                    message.mediaObject = _socialControllerService.socialData.extConfig.wxMediaObject;
                }
                
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