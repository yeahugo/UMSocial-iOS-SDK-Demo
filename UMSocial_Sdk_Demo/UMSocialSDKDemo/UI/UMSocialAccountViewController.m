//
//  UMSocialAccountViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-9-7.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialAccountViewController.h"
#import "UMSocialAccountEntity.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsService.h"
#import "AppDelegate.h"

@interface UMSocialAccountViewController ()

@end

@implementation UMSocialAccountViewController

//-(void)viewWillDisappear:(BOOL)animated{
//    [_socialUIController.socialDataService setUMSocialDelegate:nil];
//    [super viewWillDisappear:animated];
//}

-(void)dealloc
{
    SAFE_ARC_RELEASE(_socialUIController);
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _socialUIController = [[UMSocialControllerService alloc] initWithUMSocialData:[UMSocialData defaultData]];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 200);
    [self.view addSubview:_activityIndicatorView];
    _socialUIController.socialUIDelegate = self;
    [_socialUIController.socialDataService setUMSocialDelegate:self];
    
    NSDictionary *socialDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialAccountEntity *sinaAccount= [socialDic objectForKey:UMShareToSina];
    NSLog(@"username is %@",sinaAccount.userName);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == UMAccountSnsAccount) {
        cell.textLabel.text = @"sns授权信息";
    }
    if (indexPath.row == UMAccountSocialAccount) {
        cell.textLabel.text = @"个人中心";
    }
    if (indexPath.row == UMAccountLoginAccount) {
        cell.textLabel.text = @"登录信息";
    }
    if (indexPath.row == UMAccountSocialLogin) {
        cell.textLabel.text = @"登录";
    }
    if (indexPath.row == UMAccountOauth) {
        cell.textLabel.text = @"授权";
    }
    if (indexPath.row == UMAccountUnOauth) {
        cell.textLabel.text = @"解除登录";
    }  
    if (indexPath.row == UMAccountSSO) {
//        cell.textLabel.text = @"添加自有账号";
        cell.textLabel.text = @"SSO";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == UMAccountUnOauth) {
        [_socialUIController.socialDataService setUMSocialDelegate:self];
        [_socialUIController.socialDataService requestUnBindToSnsWithCompletion:nil];
        [_activityIndicatorView startAnimating];
    }
    else if (indexPath.row == UMAccountSocialAccount) {
        UINavigationController *accountViewController =[_socialUIController getSocialAccountController];
        
        [self presentModalViewController:accountViewController animated:YES];
    }
    
    else if (indexPath.row == UMAccountSnsAccount) {
        UINavigationController *accountViewController =[_socialUIController getSnsAccountController];
        [self presentModalViewController:accountViewController animated:YES];
    }
    
    else if (indexPath.row == UMAccountLoginAccount) {
        UINavigationController *accountViewController =[_socialUIController getLoginAccountController];
        
        [self presentModalViewController:accountViewController animated:YES];
    }
    
    else if(indexPath.row == UMAccountSocialLogin){
        UINavigationController *loginViewController = [_socialUIController getSocialLoginController];
        [self presentModalViewController:loginViewController animated:YES];
    }
    else if(indexPath.row == UMAccountOauth)
    {
        UIActionSheet *oauthActionSheet = [[UIActionSheet alloc] initWithTitle:@"授权" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].socialSnsArray) {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
            [oauthActionSheet addButtonWithTitle:snsPlatform.displayName];
        }
        
        [oauthActionSheet addButtonWithTitle:@"取消"];
        oauthActionSheet.cancelButtonIndex = oauthActionSheet.numberOfButtons - 1;
        [oauthActionSheet showFromTabBar:self.tabBarController.tabBar];
        UMAccountAction accountAction  = indexPath.row;
        oauthActionSheet.tag = accountAction;
        SAFE_ARC_RELEASE(oauthActionSheet);
    }
    else if (indexPath.row == UMAccountSSO){
#if __UMSocial__Support__SSO
        [[UMSocialSnsService sharedInstance].sinaWeibo logIn];
#endif
    }
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= actionSheet.numberOfButtons - 1) {
        return;
    }
    if (actionSheet.tag == UMAccountOauth) {
        NSString *snaName = [[UMSocialSnsPlatformManager sharedInstance].socialSnsArray objectAtIndex:buttonIndex];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snaName];
        snsPlatform.loginClickHandler(self,_socialUIController,YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            NSLog(@"snsType is %@",[[response.data allKeys] objectAtIndex:0]);
        });
    }
}

#pragma mark - UMSocialDelegate
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"social Account response is %@",response);
    if (response.responseType == UMSResponseUnBinding) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"解除登录成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
            SAFE_ARC_RELEASE(alertView);
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"解除登录失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
            SAFE_ARC_RELEASE(alertView);
        }
    }
    [_activityIndicatorView stopAnimating];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.viewControllerType == UMSViewControllerOauth) {
        NSLog(@"socialData is %@",_socialUIController.socialData.socialAccount);        
    }
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didCloseUIViewController from %d!!",fromViewControllerType);
}

@end
