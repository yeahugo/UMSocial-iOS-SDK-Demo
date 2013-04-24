//
//  UMSocialDataServiceViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-3-7.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialDataServiceViewController.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialShareViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"

@interface UMSocialDataServiceViewController ()

@end

@implementation UMSocialDataServiceViewController

@synthesize socialPlatform = _socialPlatform;

-(void)dealloc{
    SAFE_ARC_RELEASE(_socialDataService);
    SAFE_ARC_RELEASE(_activityIndicatorView);
    SAFE_ARC_SUPER_DEALLOC();
}

-(void)viewDidLoad
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UMSocialShareViewController *shareViewController = [[self.tabBarController viewControllers] objectAtIndex:0];
    UMSocialData *socialData = shareViewController.socialController.socialData;

    _socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:socialData];
    
    _shareTextView.text = socialData.shareText;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, _textView.frame.origin.y);
    [self.view addSubview:_activityIndicatorView];
    
    self.socialPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    [self updateOauthDescriptrionLabel];
        
    [self.view addSubview:_activityIndicatorView];
    
    [super viewDidLoad];
}

-(void)updateOauthDescriptrionLabel
{
    _socialPlatformLabel.text = self.socialPlatform.displayName;
    if ([UMSocialAccountManager isOauthWithPlatform:_socialPlatform.platformName]) {
        _oauthDescriptionLabel.textColor = [UIColor blackColor];
        _oauthDescriptionLabel.text = @"此平台已授权";
    }
    else{
        _oauthDescriptionLabel.textColor = [UIColor redColor];
        _oauthDescriptionLabel.text = @"此平台没有授权，不能直接用数据接口发送微博，和获取获取好友数据等操作。请先在个人中心授权。";
    }
}

-(IBAction)changeSocialPlatform:(id)sender
{
    UIActionSheet *socialPlatformActionSheet = [[UIActionSheet alloc] initWithTitle:@"更改分享平台" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].socialSnsArray) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        [socialPlatformActionSheet addButtonWithTitle:snsPlatform.displayName];
    }
    
    [socialPlatformActionSheet addButtonWithTitle:@"取消"];
    socialPlatformActionSheet.cancelButtonIndex = socialPlatformActionSheet.numberOfButtons - 1;
    [socialPlatformActionSheet showFromTabBar:self.tabBarController.tabBar];
    SAFE_ARC_RELEASE(socialPlatformActionSheet);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= actionSheet.numberOfButtons - 1) {
        return;
    }
    else {
        NSString *snaName = [[UMSocialSnsPlatformManager sharedInstance].socialSnsArray objectAtIndex:buttonIndex];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snaName];
        self.socialPlatform = snsPlatform;        
        [self updateOauthDescriptrionLabel];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialDataServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"获取发送微博数、评论数等";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"获取账户信息";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"发送微博";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"获取sns账号详细信息";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"获取好友数据";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"解除授权";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"添加喜欢";
    }
    if (indexPath.row == 7) {
        cell.textLabel.text = @"获取评论";
    }
    if (indexPath.row == 8) {
        cell.textLabel.text = @"添加评论";
    }
    if (indexPath.row == 9) {
        cell.textLabel.text = @"绑定登录账号";
    }
    if (indexPath.row == 10) {
        cell.textLabel.text = @"解除登录";
    }
    if (indexPath.row == 11) {
        cell.textLabel.text = @"关注“友盟SDK”新浪微博";
    }
    if (indexPath.row == 12) {
        cell.textLabel.text = @"添加授权账号";
    }
    if (indexPath.row == 13) {
        cell.textLabel.text = @"获取app信息";
    }
    if (indexPath.row == 14) {
        cell.textLabel.text = @"添加自定义账户";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_activityIndicatorView startAnimating];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UMSocialDataServiceCompletion completion =^(UMSocialResponseEntity *response){
        [_activityIndicatorView stopAnimating];
        _textView.text = [response description];
        NSLog(@"response is %@",response);
    };
    if (indexPath.row == 0) {
        [_socialDataService requestSocialDataWithCompletion:completion];
    }
    else if (indexPath.row == 1) {
        [_socialDataService requestSocialAccountWithCompletion:completion];
    }
    else if (indexPath.row == 2) {
        [_socialDataService postSNSWithTypes:[NSArray arrayWithObject:_socialPlatform.platformName] content:_socialDataService.socialData.shareText image:_socialDataService.socialData.shareImage location:nil urlResource:nil completion:completion];
    }
    else if (indexPath.row == 3){
        [_socialDataService requestSnsInformation:_socialPlatform.platformName completion:completion];
    }
    else if (indexPath.row == 4){
        [_socialDataService requestSnsFriends:_socialPlatform.platformName completion:completion];
    }
    else if (indexPath.row == 5){
        [_socialDataService requestUnOauthWithType:_socialPlatform.platformName completion:^(UMSocialResponseEntity *response){
            [_activityIndicatorView stopAnimating];
            _textView.text = [response description];
            [self updateOauthDescriptrionLabel];
            NSLog(@"response is %@",response);
        }];
    }
    else if (indexPath.row == 6) {
        [_socialDataService postAddLikeOrCancelWithCompletion:completion];
    }
    else if (indexPath.row == 7){
        [_socialDataService requestCommentList:-1 completion:completion];
    }
    else if (indexPath.row == 8) {
        [_socialDataService postCommentWithContent:_socialDataService.socialData.shareText completion:completion];
    }
    else if (indexPath.row == 9) {
        [_socialDataService requestBindToSnsWithType:_socialPlatform.platformName completion:completion];
    }
    else if (indexPath.row == 10) {
        [_socialDataService requestUnBindToSnsWithCompletion:completion];
    }
    else if (indexPath.row == 11){
        //关注新浪微博账号：友盟SDK
        [_socialDataService requestAddFollow:_socialPlatform.platformName followedUsid:[NSArray arrayWithObject:@"2937537507"] completion:completion];
    }
    else if (indexPath.row == 12){
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToTencent];
        snsAccount.usid = @"MaJiaforTest";
        snsAccount.accessToken = @"2e11f88cda3dfeecd7c1e364582168ae";
        snsAccount.openId = @"CC71DDD36F48BD9065FA38EFD4E05CBD";
        [UMSocialAccountManager postSnsAccount:snsAccount completion:completion];
    }
    else if (indexPath.row == 13){
        [UMSocialAccountManager requestAppInfo:completion];
    }
    else if (indexPath.row == 14){
        UMSocialCustomAccount *customAccount = [[UMSocialCustomAccount alloc] initWithUserName:@"customName"];
        [UMSocialAccountManager postCustomAccount:customAccount completion:completion];
        SAFE_ARC_RELEASE(customAccount);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
