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
    SAFE_ARC_RELEASE(_actionSheet);
    SAFE_ARC_RELEASE(_socialUIController);
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"QQ空间",@"新浪微博",@"腾讯微博",@"人人网",@"豆瓣",nil];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _socialData = [UMSocialData defaultData];
    _socialUIController = [[UMSocialControllerService alloc] initWithUMSocialData:_socialData];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 200);
    [self.view addSubview:_activityIndicatorView];
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 360, 300, 20)];
    _nickNameLabel.text = @"授权账号昵称";
    _nickNameLabel.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:_nickNameLabel];
    _accessTokenLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 380, 300, 20)];
    _accessTokenLable.font = [UIFont systemFontOfSize:9];
    _accessTokenLable.text = @"授权账号token";
    [self.view addSubview:_accessTokenLable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"授权账户";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"解授权";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"登录";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"解除登录";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"获取用户sns详细信息";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"获取好友列表";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"添加关注";
    }
    if (indexPath.row == 7) {
        cell.textLabel.text = @"获取账户";
    }
    if (indexPath.row == 8) {
        cell.textLabel.text = @"用户中心";
    }
    if (indexPath.row == 9) {
        cell.textLabel.text = @"登录页面";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        [_socialUIController.socialDataService requestUnBindToSns];
        [_activityIndicatorView startAnimating];
    }
    else if (indexPath.row == 7) {
        [_socialUIController.socialDataService requestSocialAccount];
        [_activityIndicatorView startAnimating];
    }
    else if (indexPath.row == 8) {
        UINavigationController *accountViewController =[_socialUIController getSocialAccountController];
        
        [self presentModalViewController:accountViewController animated:YES];
    }
    else if(indexPath.row == 9){
        UINavigationController *loginViewController = [_socialUIController getSocialLoginController];
        _socialUIController.soicalUIDelegate = self;
        [self presentModalViewController:loginViewController animated:YES];
    }
    else
    {
        [_actionSheet setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [_actionSheet showInView:self.view];
        UMAccountAction accountAction  = indexPath.row;
        _actionSheet.tag = accountAction;    
    }
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is %d",buttonIndex);
    UMSocialSnsType shareToType = buttonIndex + UMSocialSnsTypeQzone;
    if (shareToType >= UMSocialSnsTypeCount) {
        return;
    }
    if (actionSheet.tag == UMAccountOauth) {
        _selectOauthType = shareToType;
        _socialUIController.soicalUIDelegate = self;
        UINavigationController *oauthController = [_socialUIController getSocialOauthController:shareToType];
        [self presentModalViewController:oauthController animated:YES];
    }
    else if (actionSheet.tag == UMAccountUnOauth) {
        [_socialUIController.socialDataService requestUnOauthWithType:shareToType];
        [_activityIndicatorView startAnimating];
    }
    else if (actionSheet.tag == UMAccountBind) {
        [_socialUIController.socialDataService requestBindToSnsWithType:shareToType];
        [_activityIndicatorView startAnimating];
    }
    else if (actionSheet.tag == UMAccountSnsInfo){
        [_socialUIController.socialDataService setUMSocialDelegate:self];
        [_socialUIController.socialDataService requestSnsInfomation:shareToType];
        [_activityIndicatorView startAnimating];
    }
    else if (actionSheet.tag == UMAccountFriend){
        [_socialUIController.socialDataService setUMSocialDelegate:self];
        [_socialUIController.socialDataService requestSnsFriends:shareToType];
        [_activityIndicatorView startAnimating];
    }
    else if (actionSheet.tag == UMAccountAddFollow){
        [_socialUIController.socialDataService setUMSocialDelegate:self];
        [_socialUIController.socialDataService requestAddFollow:shareToType followedUsid:[NSArray arrayWithObjects:@"1920318374", nil]];
        [_activityIndicatorView startAnimating];
    }
}

#pragma mark - UMSocialDelegate

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"social Account response is %@",response);

    [_activityIndicatorView stopAnimating];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
    if (response.viewControllerType == UMSViewControllerOauth) {
        UMSocialAccountEntity *account = (UMSocialAccountEntity *)[_socialUIController.socialData.socialAccount objectForKey:[UMSocialAccountEntity getSnsPlatformString:_selectOauthType]];
        if (account.userName != nil && account.userName.length > 0) {
            _nickNameLabel.text = @"nickNameSuccess";
        }
        if (account.accessToken != nil&& account.accessToken.length > 0) {
            _accessTokenLable.text = @"accessTokenSuccess";
        }
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"fromViewControllerType is %d",fromViewControllerType);
    NSLog(@"didCloseUIViewController account is %@",(UMSocialAccountEntity *)[_socialUIController.socialData.socialAccount objectForKey:@"sina"] );
}

@end
