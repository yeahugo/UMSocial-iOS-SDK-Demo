//
//  UMSocialConfigViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-2-18.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialConfigViewController.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialConfig.h"

@interface UMSocialConfigViewController ()

@end

@implementation UMSocialConfigViewController

@synthesize supportOrientationMask = _supportOrientationMask;

-(void)dealloc
{
    SAFE_ARC_RELEASE(_shareToPlatforms);
    SAFE_ARC_RELEASE(_shareToPlatformDic);
    SAFE_ARC_RELEASE(_shareToPlatformsValues);
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.supportOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        [UMSocialConfig setSupportedInterfaceOrientations:self.supportOrientationMask];
        //设置关注的官方微博，可以设置新浪微博和腾讯微博，将会出现在授权页面下面“关注官方微博”的小勾
//        [UMSocialConfig setFollowWeiboUids:[NSDictionary dictionaryWithObjectsAndKeys:@"2937537507",UMShareToSina,nil]];
        //设置异步分享
//        [UMSocialConfig setShouldShareSynchronous:NO];
        _shareToPlatforms = [[NSMutableArray alloc] initWithObjects:[NSMutableArray  arrayWithObjects:UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,nil],[NSMutableArray arrayWithObjects:UMShareToEmail,UMShareToSms,UMShareToWechat,UMShareToFacebook,UMShareToTwitter,@"copy",nil],nil];
        _shareToPlatformsValues = [[NSArray alloc] initWithObjects:UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToWechat,UMShareToFacebook,UMShareToTwitter, nil];
#ifdef __IPHONE_6_0
            _shareToPlatformDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:UMShareToQzone,UMShareToQzone,UMShareToSina,UMShareToSina,UMShareToTencent,UMShareToTencent,UMShareToRenren,UMShareToRenren,UMShareToDouban,UMShareToDouban,UMShareToWechat,UMShareToWechat,UMShareToEmail,UMShareToEmail,UMShareToSms,UMShareToSms,UMShareToFacebook,UMShareToFacebook,UMShareToTwitter,UMShareToTwitter,nil];
#else
            _shareToPlatformDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:UMShareToQzone,UMShareToQzone,UMShareToSina,UMShareToSina,UMShareToTencent,UMShareToTencent,UMShareToRenren,UMShareToRenren,UMShareToDouban,UMShareToDouban,UMShareToWechat,UMShareToWechat,UMShareToEmail,UMShareToEmail,UMShareToSms,UMShareToSms, nil];
#endif

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UMSocialConfigDelegate
- (NSArray *)shareToPlatforms
{
    NSMutableArray *shareToPlatforms = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithArray:[_shareToPlatforms objectAtIndex:0]],[NSMutableArray arrayWithArray:[_shareToPlatforms objectAtIndex:1]],nil];
    for (int i = 0;i<_shareToPlatforms.count;i++) {
        NSMutableArray *snsArray = [_shareToPlatforms objectAtIndex:i];
        for (NSString *snsName in snsArray) {
            if (nil == [_shareToPlatformDic objectForKey:snsName]) {
                NSMutableArray *snsArrayInPlatform = [shareToPlatforms objectAtIndex:i];
                [snsArrayInPlatform removeObject:snsName];
            }
        }
    }
    return shareToPlatforms;
}

-(CGSize)boundSizeForiPad
{
    return CGSizeMake(500, 300);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    if (section == 0) {
        sectionTitle = @"屏幕方向";
    }
    else if (section == 1) {
        sectionTitle = @"显示微博平台";
    }
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = 0;
    if (section == 0) {
        number = 4;
    }
    else if (section == 1){
        number = 10;
    }
    else if(section == 2){
        number = 1;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialConfig";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Portrait";
            if (_supportOrientationMask == UIInterfaceOrientationMaskPortrait) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"AllButUpsideDown";
            if (_supportOrientationMask == UIInterfaceOrientationMaskAllButUpsideDown) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"Landscape";
            if (_supportOrientationMask == UIInterfaceOrientationMaskLandscape) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 3){
            cell.textLabel.text = @"All";
            if (_supportOrientationMask == UIInterfaceOrientationMaskAll) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"QQ空间";
            if ([_shareToPlatformDic objectForKey:UMShareToQzone]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"新浪微博";
            if ([_shareToPlatformDic objectForKey:UMShareToSina]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"腾讯微博";
            if ([_shareToPlatformDic objectForKey:UMShareToTencent]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 3){
            cell.textLabel.text = @"人人网";
            if ([_shareToPlatformDic objectForKey:UMShareToRenren]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 4){
            cell.textLabel.text = @"豆瓣";
            if ([_shareToPlatformDic objectForKey:UMShareToDouban]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 5){
            cell.textLabel.text = @"邮件";
            if ([_shareToPlatformDic objectForKey:UMShareToEmail]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 6){
            cell.textLabel.text = @"短信";
            if ([_shareToPlatformDic objectForKey:UMShareToSms]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 7){
            cell.textLabel.text = @"微信";
            if ([_shareToPlatformDic objectForKey:UMShareToWechat]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 8){
            cell.textLabel.text = @"Facebook";
            if ([_shareToPlatformDic objectForKey:UMShareToFacebook]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else if (indexPath.row == 9){
            cell.textLabel.text = @"Twitter";
            if ([_shareToPlatformDic objectForKey:UMShareToTwitter]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"增加自定义渠道--复制";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return _supportOrientationMask;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        int nums = [tableView numberOfRowsInSection:indexPath.section];
        for (int i = 0; i < nums; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            UITableViewCell *cellView = [tableView cellForRowAtIndexPath:path];
            cellView.accessoryType = UITableViewCellAccessoryNone;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];        
    }
    
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    if (cellView.accessoryType == UITableViewCellAccessoryNone) {
        cellView.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else {
        cellView.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.supportOrientationMask = UIInterfaceOrientationMaskPortrait;
        }
        else if (indexPath.row == 1){
            self.supportOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        }
        else if (indexPath.row == 2){
            self.supportOrientationMask = UIInterfaceOrientationMaskLandscape;
        }
        else if (indexPath.row == 3){
            self.supportOrientationMask = UIInterfaceOrientationMaskAll;
        }
        [UMSocialConfig setSupportedInterfaceOrientations:self.supportOrientationMask];
    }
    else if (indexPath.section == 1){
        BOOL isSelect = cellView.selected;
        NSString *snsName = [_shareToPlatformsValues objectAtIndex:indexPath.row];
        if (isSelect) {
            [_shareToPlatformDic setObject:snsName forKey:snsName];
        }
        else{
            [_shareToPlatformDic removeObjectForKey:snsName];
        }
        [UMSocialConfig setSnsPlatformNames:[self shareToPlatforms]];
    }
    else if (indexPath.section == 2){
        UMSocialSnsPlatform *copyPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"copy"];
        copyPlatform.displayName = @"复制";
        copyPlatform.smallImageName = @"icon"; //用于tableView样式的分享列表
        copyPlatform.bigImageName = @"icon";   //用于actionsheet样式的分享列表
        copyPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
            NSLog(@"copy!");
        };
        BOOL isSelect = cellView.selected;
        if (isSelect) {
            [_shareToPlatformDic setObject:copyPlatform.platformName forKey:copyPlatform.platformName];
        }
        else if([_shareToPlatformDic objectForKey:copyPlatform.platformName]){
            [_shareToPlatformDic removeObjectForKey:copyPlatform.platformName];
        }
        [UMSocialConfig addSocialSnsPlatform:[NSArray arrayWithObject:copyPlatform]];
        [UMSocialConfig setSnsPlatformNames:[self shareToPlatforms]];
    }
}

@end
