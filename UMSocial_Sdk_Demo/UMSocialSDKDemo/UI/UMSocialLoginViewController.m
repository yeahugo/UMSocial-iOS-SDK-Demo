//
//  UMSocialLoginViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-5-19.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialLoginViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"

@interface UMSocialLoginViewController ()

@end

@implementation UMSocialLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _snsTableView.dataSource = self;
    _snsTableView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_snsTableView reloadData];
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSnsAccountCellIdentifier = @"UMSnsAccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSnsAccountCellIdentifier];
    
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[UMSocialSnsPlatformManager getSnsPlatformStringFromIndex:indexPath.row]];
    
    UMSocialAccountEntity *accountEnitity = [snsAccountDic valueForKey:snsPlatform.platformName];
    
    UISwitch *oauthSwitch = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:UMSnsAccountCellIdentifier] ;
        
    }
    
    oauthSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
    oauthSwitch.center = CGPointMake(tableView.bounds.size.width - oauthSwitch.frame.size.width/2 - 15, oauthSwitch.center.y);
    oauthSwitch.tag = 10 + snsPlatform.shareToType;
    [cell addSubview:oauthSwitch];
    [oauthSwitch addTarget:self action:@selector(onSwitchOauth:) forControlEvents:UIControlEventValueChanged];
    
    NSString *showUserName = nil;
    if (accountEnitity.userName != nil) {
        [oauthSwitch setOn:YES];
        showUserName = accountEnitity.userName;
    }
    else {
        [oauthSwitch setOn:NO];
        showUserName = [NSString stringWithFormat:@"尚未授权"];
    }
    
    if (![showUserName isKindOfClass:[NSNull class]]) {
        if ([showUserName isEqualToString:@""]) {
            cell.textLabel.text = @"已授权";
        }
        else{
            cell.textLabel.text = showUserName;
        }
    }
    else{
        cell.textLabel.text = @"已授权";
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.imageView.image = [UIImage imageNamed:snsPlatform.smallImageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)onSwitchOauth:(UISwitch *)switcher
{
    _changeSwitcher = switcher;
    if (switcher.isOn == YES) {
        [switcher setOn:NO];
        NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:switcher.tag - 10];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            [_snsTableView reloadData];
        });
    }
    else {
        UIActionSheet *unOauthActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除授权", nil];
        unOauthActionSheet.destructiveButtonIndex = 0;
        unOauthActionSheet.tag = switcher.tag - 10;
        [unOauthActionSheet showInView:self.tabBarController.tabBar];
    }
}


#pragma UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:actionSheet.tag];
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response){
            if (response.responseType == UMSResponseGetAccount) {
                [_snsTableView reloadData];                
            }
        }];
    }
    else {//按取消
        [_changeSwitcher setOn:YES animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
