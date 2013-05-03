//
//  UMSocialSnsPlatformManager.m
//  SocialSDK
//
//  Created by yeahugo on 13-1-15.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"
#import "UMSocialAccountManager.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"
#import <MessageUI/MessageUI.h>
#import "UMSocialMacroDefine.h"

@implementation UMSocialSnsPlatformManager

@synthesize allSnsArray = _allSnsArray;
@synthesize allSnsValuesArray = _allSnsValuesArray;
@synthesize socialSnsArray = _socialSnsArray;
@synthesize allSnsPlatformDictionary = _allSnsPlatformDictionary;
@synthesize appInfo = _appInfo;

+ (UMSocialSnsPlatformManager *)sharedInstance
{
	static UMSocialSnsPlatformManager *_instance = nil;
    
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [[self alloc] init];
		}
	}
    
	return _instance;
}

-(id)init
{
    self = [super init];
    {
        if (self) {
            _allSnsArray = nil;
            _socialSnsArray = nil;
            _allSnsValuesArray = nil;

            [self initSNSDescriptrorArray];
        }
    }
    return self;
}

+(UMSocialSnsPlatform *)getSocialPlatformWithName:(NSString *)snsName
{
    return [[UMSocialSnsPlatformManager sharedInstance] getSnsPlatformWithName:snsName];
}

+(NSString *)getSnsPlatformString:(UMSocialSnsType)socialSnsType
{
    NSString *returnSnsString = nil;
    UMSocialSnsPlatform *snsDescriptor = [[UMSocialSnsPlatformManager sharedInstance] getSnsPlatformWithType:socialSnsType];
    returnSnsString = snsDescriptor.platformName;
    
    if (snsDescriptor == nil) {
        NSLog(@"UMSocial----socialSnsType error!");
    }
    return returnSnsString;
}

+(UMSocialSnsType)getSnsPlatformType:(NSString *)socialSnsString
{
    UMSocialSnsPlatform *snsDescriptor = [[UMSocialSnsPlatformManager sharedInstance] getSnsPlatformWithName:socialSnsString];
    UMSocialSnsType socialSnsType = UMSocialSnsTypeNone;
    if (snsDescriptor != nil) {
        socialSnsType = (UMSocialSnsType)snsDescriptor.shareToType;
    }
    else{
        NSLog(@"UMSocial----socialSnsString error!");
    }
    return socialSnsType;
}

-(NSArray *)socialSnsArray
{
    //配置显示sns的类型，如果不配置的话，默认可以显示全部
    NSMutableArray *allConfigArray = [[NSMutableArray alloc] initWithArray:self.allSnsValuesArray];
    NSMutableArray *snsConfigArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < allConfigArray.count; i++) {
        NSString *configSnsName = [allConfigArray objectAtIndex:i];
        NSDictionary *configSnsDic = _snsPlatformDictionary;
        if ([configSnsDic objectForKey:configSnsName]) {
            [snsConfigArray addObject:configSnsName];
        }
    }
    SAFE_ARC_RELEASE(_socialSnsArray);
    _socialSnsArray = [[NSArray alloc] initWithArray:snsConfigArray];
    SAFE_ARC_RELEASE(snsConfigArray);
    SAFE_ARC_RELEASE(allConfigArray);
    return _socialSnsArray;
}

-(NSArray *)allSnsArray
{
    //配置显示sns的类型，如果不配置的话，默认可以显示全部
    return [UMSocialConfig shareInstance].snsPlatformNames;
}

-(NSArray *)allSnsValuesArray
{
    //配置显示sns的类型，如果不配置的话，默认可以显示全部
    NSMutableArray * allSnsConfigValuesArray = [[NSMutableArray alloc] init];
    NSArray *allConfigArray = self.allSnsArray;
    for (int i = 0; i < allConfigArray.count; i++) {
        id snsObject = [allConfigArray objectAtIndex:i];
        if ([snsObject isKindOfClass:[NSArray class]]) {
            for (int j = 0 ; j < [snsObject count]; j++) {
                NSString *snsString = [snsObject objectAtIndex:j];
                [allSnsConfigValuesArray addObject:snsString];
            }
        }else{
            [allSnsConfigValuesArray addObject:snsObject];
        }
    }
    SAFE_ARC_RELEASE(_allSnsValuesArray);
    _allSnsValuesArray = [[NSMutableArray alloc] initWithArray:allSnsConfigValuesArray];
    SAFE_ARC_RELEASE(allSnsConfigValuesArray);

    return _allSnsValuesArray;
}


-(void)initSNSDescriptrorArray
{
    _allSnsPlatformDictionary = [[NSMutableDictionary alloc] init];
    _snsPlatformDictionary = [[NSMutableDictionary alloc] init];
    for (int i = UMSocialSnsTypeQzone; i < UMSocialSnsTypeEmail; i ++) {
        UMSocialSnsPlatform *snsDescriptor = [self makeSNSDescriptorWithType:i];
        [_allSnsPlatformDictionary setObject:snsDescriptor forKey:snsDescriptor.platformName];
        [_snsPlatformDictionary setObject:snsDescriptor forKey:snsDescriptor.platformName];
    }
    UMSocialSnsPlatform *emailPlatform = [self makeSNSDescriptorWithType:UMSocialSnsTypeEmail];
    [_allSnsPlatformDictionary setObject:emailPlatform forKey:UMShareToEmail];
    UMSocialSnsPlatform *smsPlatform = [self makeSNSDescriptorWithType:UMSocialSnsTypeSms];
    [_allSnsPlatformDictionary setObject:smsPlatform forKey:UMShareToSms];
    UMSocialSnsPlatform *wxSessionPlatform = [self makeSNSDescriptorWithType:UMSocialSnsTypeSms + 1];
    wxSessionPlatform.platformName = UMShareToWechatSession;
    [_allSnsPlatformDictionary setObject:wxSessionPlatform forKey:UMShareToWechatSession];
    UMSocialSnsPlatform *wxTimelinePlatform = [self makeSNSDescriptorWithType:UMSocialSnsTypeSms + 2 ];
    wxTimelinePlatform.platformName = UMShareToWechatTimeline;
    [_allSnsPlatformDictionary setObject:wxTimelinePlatform forKey:UMShareToWechatTimeline];
    [self makeSnsHandler];
}

+(NSString *)getSnsPlatformStringFromIndex:(int)snsIndex
{
    UMSocialSnsPlatform *snsDescriptor = [[UMSocialSnsPlatformManager sharedInstance] getSnsPlatformWithIndex:snsIndex];
    NSString * snsName = nil;
    if (snsDescriptor != nil) {
        snsName = snsDescriptor.platformName;
    }
    else{
        NSLog(@"UMSocial----sns index error!");
    }
    return snsName;
}

- (id)getSnsPlatformWithType:(UMSocialSnsType)shareToType
{
    id returnDescriptor = nil;
    
    for (NSString *snsName in _allSnsPlatformDictionary) {
        UMSocialSnsPlatform *snsPlatform = [_allSnsPlatformDictionary objectForKey:snsName];
        if (snsPlatform.shareToType == shareToType) {
            returnDescriptor = snsPlatform;
            return returnDescriptor;
        }
    }
    return returnDescriptor;
}

-(id)getSnsPlatformWithIndex:(NSInteger)index
{
    NSString *snsName = [[UMSocialSnsPlatformManager sharedInstance].socialSnsArray objectAtIndex:index];
    return [self getSnsPlatformWithName:snsName];
}

- (id)getSnsPlatformWithName:(NSString *)snsName
{
    @try {
        id snsDescriptor = nil;
        snsDescriptor = [_allSnsPlatformDictionary objectForKey:snsName];
        
        if (snsDescriptor == nil) {
            
            NSLog(@"UMSocial----getSnsPlatformWithName snsName is %@",snsName);
            
            if (!([snsName isEqualToString:@"loginAccount"] )) {
                NSLog(@"UMSocial----%@, Error: displayName error!",snsName);
            }
        }
        
        return snsDescriptor;
    }
    @catch (NSException *exception) {
        NSLog(@"UMSocial----you must set the snsName as a NSString not a NSNumber !");
    }
    @finally {
        
    }
}

-(void)makeSnsHandler
{
    for (NSString *snsName in _allSnsPlatformDictionary) {
//        UMLog(@"makeSnsHandler's name is %@",snsName);
        [self makeDefaultSnsHandlerWithName:snsName];
    }
}


+(void)handleOauthWithSnsName:(NSString *)snsName controllerService:(UMSocialControllerService *)controllerService controller:(UIViewController *)controller authorization:(void (^)(void))authorization completion:(UMSocialDataServiceCompletion)completion
{
    [UMSocialSnsService sharedInstance].completion = completion;
    [UMSocialSnsService sharedInstance].authorization = authorization;
    
#if __UMSocial__Support__SSO    
    if ([snsName isEqualToString:UMShareToSina]) {
        if ([UMSocialSnsPlatformManager sharedInstance].appInfo != nil && [[UMSocialSnsPlatformManager sharedInstance].appInfo valueForKey:UMShareToSina]) {
            NSString *appkey = [[[UMSocialSnsPlatformManager sharedInstance].appInfo valueForKey:UMShareToSina] valueForKey:@"key"];
            NSString *secret = [[[UMSocialSnsPlatformManager sharedInstance].appInfo valueForKey:UMShareToSina] valueForKey:@"secret"];
            SinaWeibo * sinaWeibo = [UMSocialSnsService sharedInstance].sinaWeibo;
            sinaWeibo.userID = nil;
            sinaWeibo.appKey = appkey;
            sinaWeibo.accessToken = secret;
            sinaWeibo.ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", sinaWeibo.appKey];
            [sinaWeibo logIn];
            sinaWeibo.delegate = [UMSocialSnsService sharedInstance];
        }
        else{
            UIView *maskView = [[NSClassFromString(@"UMMaskView") alloc] performSelector:@selector(initWithRoundedView)];
            [controller.view addSubview:maskView];
            SAFE_ARC_RELEASE(maskView);
            [UMSocialAccountManager requestAppInfo:^(UMSocialResponseEntity * response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self sharedInstance].appInfo = response.data;
                    if ([response.data  valueForKey:UMShareToSina]) {
                        [maskView removeFromSuperview];
                        NSString *appkey = [[[self sharedInstance].appInfo valueForKey:UMShareToSina] valueForKey:@"key"];
                        NSString *secret = [[[self sharedInstance].appInfo valueForKey:UMShareToSina] valueForKey:@"secret"];
                        SinaWeibo * sinaWeibo = [UMSocialSnsService sharedInstance].sinaWeibo;
                        sinaWeibo.userID = nil;
                        sinaWeibo.appKey = appkey;
                        sinaWeibo.accessToken = secret;
                        sinaWeibo.ssoCallbackScheme = [NSString stringWithFormat:@"sinaweibosso.%@://", sinaWeibo.appKey];
                        [sinaWeibo logIn];
                        sinaWeibo.delegate = [UMSocialSnsService sharedInstance];
                    }
                }
            }];
        }
    }
    else{
        if (authorization != nil) {
            authorization();
        }
    }
#else
    if (authorization != nil) {
        authorization();
    }
#endif
}



-(void)makeDefaultSnsHandlerWithName:(NSString *)snsName
{
    UMSocialSnsPlatform *snsPlatform = [_allSnsPlatformDictionary objectForKey:snsName];
    
    UMSocialSnsPlatformLoginHandler loginClick = ^(UIViewController *presentingController,UMSocialControllerService * controllerService, BOOL isPresentInController, UMSocialDataServiceCompletion loginCompletion){
        if (controllerService.nextViewController != -1) {
            UIView *maskView = [[NSClassFromString(@"UMMaskView") alloc] performSelector:@selector(initWithRoundedView)];
            [presentingController.view addSubview:maskView];
            maskView.tag = 1000;
            SAFE_ARC_RELEASE(maskView);
        }

        UMSocialSnsType snsType = snsPlatform.shareToType;
        if (snsType >= UMSocialSnsTypeQzone && snsType <  UMSocialSnsTypeEmail) {
           
            void (^handleOauth)() = ^(void){
                UIViewController *oauthViewController = [controllerService getSocialViewController:UMSViewControllerOauth withSnsType:snsName];
                if (isPresentInController == NO) {
                    [presentingController.navigationController pushViewController:oauthViewController animated:YES];
                }
                else{
                    UINavigationController *oauthNavigationController = [controllerService getSocialOauthController:snsName];
                    [presentingController presentModalViewController:oauthNavigationController animated:YES];
                }
            };
            
            void (^completion)(UMSocialResponseEntity *response) =^(UMSocialResponseEntity *response){
                if ([presentingController.view viewWithTag:1000]) {
                    UIView *maskView = [presentingController.view viewWithTag:1000];
                    [maskView removeFromSuperview];                    
                }
                
#if __UMSocial__Support__SSO
                if ([[UMSocialSnsService sharedInstance].sinaWeibo isAuthValid]) {
                    if (controllerService.socialUIDelegate != nil && [controllerService.socialUIDelegate respondsToSelector:@selector(didFinishGetUMSocialDataInViewController:)]) {
                        [controllerService.socialUIDelegate didFinishGetUMSocialDataInViewController:response];
                    }
                    
                    if (controllerService.socialUIDelegate != nil && [controllerService.socialUIDelegate respondsToSelector:@selector(didCloseUIViewController:)]) {
                        [controllerService.socialUIDelegate didCloseUIViewController:UMSViewControllerOauth];
                    }                    
                }
#endif
                loginCompletion(response);
            };
            

            [UMSocialSnsPlatformManager handleOauthWithSnsName:snsName controllerService:[UMSocialControllerService defaultControllerService] controller:presentingController authorization:handleOauth completion:completion];
        }
        else if(snsType == UMSocialSnsTypeEmail){
            NSLog(@"UMSocial----%@ platform is not support login!",snsPlatform.platformName);
        }
    };
    snsPlatform.loginClickHandler = loginClick;
    
    UMSocialSnsPlatformClickHandler snsHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController)
    {
        UMSocialSnsType snsType = snsPlatform.shareToType;
        
        if (snsType >= UMSocialSnsTypeQzone && snsType <  UMSocialSnsTypeEmail) {
            UIView *maskView = [[NSClassFromString(@"UMMaskView") alloc] performSelector:@selector(initWithRoundedView)];
            [presentingController.view addSubview:maskView];
            
            void (^finishOauth)(UMSocialResponseEntity *response) = ^(UMSocialResponseEntity *response){
                [maskView removeFromSuperview];
                SAFE_ARC_BLOCK_RELEASE(maskView);
                if (response.responseCode == UMSResponseCodeSuccess || response == nil) {
                    UIViewController *shareEditViewController = [socialControllerService getSocialViewController:UMSViewControllerShareEdit withSnsType:snsName];
                    
                    if (isPresentInController == NO) {
                        [presentingController.navigationController pushViewController:shareEditViewController animated:YES];
                    }
                    else{
                        UINavigationController *shareEditNavigationController = [socialControllerService getSocialShareEditController:snsName];
                        [presentingController presentModalViewController:shareEditNavigationController animated:YES];
                    }
                }
                else if(response != nil && response.responseCode != UMSResponseCodeCancel){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"服务器繁忙，请稍后再试" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                    [alertView show];
                }
                
                
            };
            
#if __UMSocial__Support__SSO
            if (![UMSocialAccountManager isOauthWithPlatform:snsName]) {
                [UMSocialSnsPlatformManager handleOauthWithSnsName:snsName controllerService:socialControllerService controller:presentingController authorization:^()
                {
                    finishOauth(nil);
                } completion:finishOauth];
            }
            else{
                finishOauth(nil);
            }
#else
            finishOauth(nil);
#endif
        }
        else if(snsType == UMSocialSnsTypeEmail){
            if (![NSClassFromString(@"MFMailComposeViewController") canSendMail]) {
                UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"邮件功能未开启" message:@"您当前设备的邮件服务处于未启用状态，若想通过邮件分享，请到设置中设置邮件服务后，再进行分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [servicesDisabledAlert show];
                SAFE_ARC_RELEASE(servicesDisabledAlert);
            }
            else{
                UINavigationController *emailController = [socialControllerService getSocialShareEditController:snsName];
                [presentingController presentModalViewController:emailController animated:YES];
            }
        }
        else if (snsType == UMSocialSnsTypeSms){
            if (![NSClassFromString(@"MFMessageComposeViewController") canSendText] && [snsName isEqualToString:@"sms"]) {
                UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [servicesDisabledAlert show];
                SAFE_ARC_RELEASE(servicesDisabledAlert);
            }
            else{
                UINavigationController *smsController = [socialControllerService getSocialShareEditController:snsName];
                [presentingController presentModalViewController:smsController animated:YES];
            }
        }
    };
    snsPlatform.snsClickHandler = snsHandler;
}

-(UMSocialSnsPlatform *)makeSNSDescriptorWithType:(UMSocialSnsType)shareToType
{
	UMSocialSnsPlatform *scSnsDescriptor = [[UMSocialSnsPlatform alloc] init];
    SAFE_ARC_AUTORELEASE(scSnsDescriptor);
    
	switch (shareToType) {
		case UMSocialSnsTypeSina:
        {
            scSnsDescriptor.platformName = @"sina";
            scSnsDescriptor.oauthBaseURLString	= @"share/auth";
            scSnsDescriptor.oauthCallBackPath	= @"/sina2/main";
            scSnsDescriptor.displayName = @"新浪微博";
            scSnsDescriptor.loginName       = @"新浪微博";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_sina_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_sina_off";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_sina_on";
            scSnsDescriptor.shareToType		= UMSocialSnsTypeSina;
            break;
        }
            
		case UMSocialSnsTypeTenc:
        {
            scSnsDescriptor.platformName = @"tencent";
            scSnsDescriptor.oauthBaseURLString	= @"share/auth";
            scSnsDescriptor.oauthCallBackPath	= @"/tenc2/main";
            scSnsDescriptor.displayName = @"腾讯微博";
            scSnsDescriptor.loginName           = @"腾讯微博";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_tencent_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_tencent_off";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_tencent_on";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeTenc;
            break;
        }
            
		case UMSocialSnsTypeRenr:
        {
            scSnsDescriptor.platformName = @"renren";
            scSnsDescriptor.oauthBaseURLString	= @"share/auth";
            scSnsDescriptor.oauthCallBackPath	= @"/renr2/main";
            scSnsDescriptor.displayName = @"人人网";
            scSnsDescriptor.loginName           = @"人人网";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_renren_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_renren_off";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_renren_on";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeRenr;
            break;
        }
            
		case UMSocialSnsTypeDouban:
        {
            scSnsDescriptor.platformName = @"douban";
            scSnsDescriptor.oauthBaseURLString	= @"share/auth";
            scSnsDescriptor.oauthCallBackPath	= @"/douban/main";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_douban_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_douban_off";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_douban_on";
            scSnsDescriptor.displayName = @"豆瓣";
            scSnsDescriptor.loginName           = @"豆瓣";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeDouban;
            break;
        }
            
        case UMSocialSnsTypeQzone:
        {
            scSnsDescriptor.platformName = @"qzone";
            scSnsDescriptor.oauthBaseURLString	= @"share/auth";
            scSnsDescriptor.oauthCallBackPath	= @"/qzone/main";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_qzone_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_qzone_off";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_qzone_on";
            scSnsDescriptor.displayName = @"QQ空间";
            scSnsDescriptor.loginName           = @"QQ账号";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeQzone;
            break;
        }
        case UMSocialSnsTypeEmail:
        {
            scSnsDescriptor.platformName = @"email";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_email_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_mail_on";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_mail_on";
            scSnsDescriptor.displayName = @"邮件";
            scSnsDescriptor.loginName           = @"邮箱账号";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeEmail;
            break;
        }
        case UMSocialSnsTypeSms:
        {
            scSnsDescriptor.platformName = @"sms";
            scSnsDescriptor.bigImageName = @"UMSocialSDKResources.bundle/UMS_sms_icon";
            scSnsDescriptor.smallImageOffName = @"UMSocialSDKResources.bundle/UMS_sms_on";
            scSnsDescriptor.smallImageName = @"UMSocialSDKResources.bundle/UMS_sms_on";
            scSnsDescriptor.displayName = @"短信";
            scSnsDescriptor.loginName           = @"手机号";
            scSnsDescriptor.shareToType         = UMSocialSnsTypeSms;
            break;
        }
            
		default:
//			scSnsDescriptor = nil;
//			NSLog(@"UMSocial----ERROR: UMShareToType is not vavid");
			break;
	}
	return scSnsDescriptor;
}


@end
