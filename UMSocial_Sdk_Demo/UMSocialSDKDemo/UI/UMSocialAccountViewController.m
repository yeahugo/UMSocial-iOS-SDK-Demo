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

@interface UMSocialAccountViewController ()

@end

@implementation UMSocialAccountViewController

-(void)viewWillDisappear:(BOOL)animated{
    [_socialUIController.socialDataService setUMSocialDelegate:nil];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_socialUIController.socialDataService setUMSocialDelegate:self];
    [super viewWillAppear:animated];
}
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
    _socialData = [[UMSocialData alloc] initWithIdentifier:@"abc"];
    _socialUIController = [[UMSocialControllerService alloc] initWithUMSocialData:_socialData];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 200);
    [self.view addSubview:_activityIndicatorView];
    _socialUIController.socialUIDelegate = self;
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
    if (indexPath.row == UMAccountAddCustomAccount) {
        cell.textLabel.text = @"添加自有账号";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == UMAccountUnOauth) {
        [_socialUIController.socialDataService setUMSocialDelegate:self];
        [_socialUIController.socialDataService requestUnBindToSns];
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
    else if (indexPath.row == UMAccountAddCustomAccount){
        UMSocialCustomAccount *customAccoutn = [[UMSocialCustomAccount alloc] initWithUserName:@"testName"];
        customAccoutn.usid = @"123";
        customAccoutn.customData = [NSDictionary dictionaryWithObject:@"level1" forKey:@"level"];
        [UMSocialAccountManager addCustomAccount:customAccoutn];
        SAFE_ARC_RELEASE(customAccoutn);
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
    }
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is %d",buttonIndex);
    
    if (buttonIndex >= actionSheet.numberOfButtons - 1) {
        return;
    }
    if (actionSheet.tag == UMAccountOauth) {
        NSString *snaName = [[UMSocialSnsPlatformManager sharedInstance].socialSnsArray objectAtIndex:buttonIndex];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snaName];
        
        UINavigationController *oauthController = [_socialUIController getSocialOauthController:snsPlatform.platformName];
        [self presentModalViewController:oauthController animated:YES];
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
    NSLog(@"socialData is %@",_socialUIController.socialData.socialAccount);
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didCloseUIViewController from %d!!",fromViewControllerType);
}

@end
