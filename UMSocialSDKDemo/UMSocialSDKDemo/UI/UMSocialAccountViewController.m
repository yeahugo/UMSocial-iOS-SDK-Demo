//
//  UMSocialAccountViewController.m
//  SocialSDK
//
//  Created by yeahugo on 12-9-7.
//
//

#import "UMSocialAccountViewController.h"

@interface UMSocialAccountViewController ()

@end

@implementation UMSocialAccountViewController

-(void)dealloc
{
    [_actionSheet release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"腾讯微博",@"人人网",@"豆瓣",nil];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UMSocialData defaultData] setUMSoicalDelegate:self];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
        cell.textLabel.text = @"获取账户";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"登录";
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
        [UMSocialDataAPI requestUnBindToSns];
    }
    else if (indexPath.row == 4) {
        [UMSocialDataAPI requestSocialAccount];
    }
    else if (indexPath.row == 5) {
        UIViewController *loginViewController = [UMSocialUIController getLoginViewController];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    else if (indexPath.row == 6) {
        UIViewController *accountViewController =[UMSocialUIController getAccountViewController];
        [self.navigationController pushViewController:accountViewController animated:YES];
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
    UMShareToType shareToType = buttonIndex;
    if (buttonIndex >= UMShareToTypeCount) {
        return;
    }
    if (actionSheet.tag == UMAccountOauth) {
        UIViewController *oauthController = [UMSocialUIController getOauthViewController:shareToType];
        [self.navigationController pushViewController:oauthController animated:YES];
    }
    else if (actionSheet.tag == UMAccountUnOauth) {
        [UMSocialDataAPI requestUnOauthWithType:shareToType];
    }
    else if (actionSheet.tag == UMAccountBind) {
        [UMSocialDataAPI requestBindToSnsWithType:shareToType];
    }
}

#pragma mark - UMSocialDelegate

-(void)didFinishGetUMSocialResponse:(UMSResponseEntity *)response
{
    NSLog(@"response is %@",response);
}

@end
