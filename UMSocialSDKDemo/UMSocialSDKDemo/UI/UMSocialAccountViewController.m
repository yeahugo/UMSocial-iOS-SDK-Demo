//
//  UMSocialAccountViewController.m
//  SocialSDK
//
//  Created by yeahugo on 12-9-7.
//
//

#import "UMSocialAccountViewController.h"
#import "UMSocialAccountEntity.h"

@interface UMSocialAccountViewController ()

@end

@implementation UMSocialAccountViewController

-(void)viewWillDisappear:(BOOL)animated{
    [_socialUIController.socialDataService setUMSoicalDelegate:nil];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_socialUIController.socialDataService setUMSoicalDelegate:self];
    [super viewWillAppear:animated];
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
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"test"];
    _socialUIController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 200);
    [self.view addSubview:_activityIndicatorView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"授权账户";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"解授权";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"绑定";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"解除绑定";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"获取用户sns详细信息";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"获取账户";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"用户中心";
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
    else if (indexPath.row == 5) {
        [_socialUIController.socialDataService requestSocialAccount];
        [_activityIndicatorView startAnimating];
    }
    else if (indexPath.row == 6) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"test1231"];
        UMSocialControllerService *socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        UINavigationController *accountViewController =[socialController getSocialAccountController];

//        UINavigationController *accountViewController =[_socialUIController getSocialAccountController];
        [self presentModalViewController:accountViewController animated:YES];
        
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
    UMShareToType shareToType = buttonIndex + UMShareToTypeQzone;
    if (shareToType >= UMShareToTypeCount) {
        return;
    }
    if (actionSheet.tag == UMAccountOauth) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"test1231"];
        UMSocialControllerService *socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        [socialController setUMSocialUIDelegate:self];
        UINavigationController *oauthController = [socialController getSocialOauthController:shareToType];
//        UINavigationController *oauthController = [_socialUIController getSocialOauthController:shareToType];
        [self presentModalViewController:oauthController animated:YES];
//        [self.navigationController pushViewController:oauthController.visibleViewController animated:YES];
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
        [_socialUIController.socialDataService setUMSoicalDelegate:self];
        [_socialUIController.socialDataService requestSnsInfomation:shareToType];
        [_activityIndicatorView startAnimating];
    }
}

#pragma mark - UMSocialDelegate

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"response is %@",response);
    if (response.responseType == UMSResponseGetAccount || response.responseType == UMSResponseGetSnsInfo) {
        [_activityIndicatorView stopAnimating];
    }
}

-(void)didCloseUIViewController
{
    NSLog(@"didCloseUIViewController account is %@ token is %@",(UMSocialAccountEntity *)[_socialUIController.soicalData.socialAccount objectForKey:@"sina"],[(UMSocialAccountEntity *)[_socialUIController.soicalData.socialAccount objectForKey:@"sina"] accessToken]);
    NSLog(@"授权完成");
}

@end
