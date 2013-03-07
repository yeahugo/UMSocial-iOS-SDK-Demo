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
        _shareToPlatforms = [[NSMutableArray alloc] initWithObjects:[NSMutableArray  arrayWithObjects:UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,nil],[NSMutableArray arrayWithObjects:UMShareToEmail,UMShareToSms,UMShareToWechat,UMShareToFacebook,UMShareToTwitter,nil],nil];
        _shareToPlatformsValues = [[NSArray alloc] initWithObjects:UMShareToQzone,UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToWechat,UMShareToFacebook,UMShareToTwitter, nil];
#ifdef __IPHONE_6_0
            _shareToPlatformDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:UMShareToQzone,UMShareToQzone,UMShareToSina,UMShareToSina,UMShareToTencent,UMShareToTencent,UMShareToRenren,UMShareToRenren,UMShareToDouban,UMShareToDouban,UMShareToWechat,UMShareToWechat,UMShareToEmail,UMShareToEmail,UMShareToSms,UMShareToSms,UMShareToFacebook,UMShareToFacebook,UMShareToTwitter,UMShareToTwitter, nil];
#else
            _shareToPlatformDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:UMShareToQzone,UMShareToQzone,UMShareToSina,UMShareToSina,UMShareToTencent,UMShareToTencent,UMShareToRenren,UMShareToRenren,UMShareToDouban,UMShareToDouban,UMShareToWechat,UMShareToWechat,UMShareToEmail,UMShareToEmail,UMShareToSms,UMShareToSms, nil];
#endif
        [UMSocialControllerService setSocialConfigDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UMSocialConfigDelegate

/*设置支持的屏幕方向，iPhone设备默认只支持UIInterfaceOrientationPortrait，iPad设备默认支持4个方向
 */
- (NSUInteger)supportedInterfaceOrientationsForUMSocialSDK
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    return _supportOrientationMask;
#else
    return 1 << UIInterfaceOrientationPortrait | 1 << UIInterfaceOrientationLandscapeLeft | 1 << UIInterfaceOrientationLandscapeRight;
#endif
}


//- (UMSocialSnsPlatform *)socialSnsPlatformWithSnsName:(NSString *)snsName
//{
//    UMSocialSnsPlatform *customSnsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:snsName];
//    SAFE_ARC_AUTORELEASE(customSnsPlatform);
//    if ([snsName isEqualToString:@"copy"]) {
//        customSnsPlatform.bigImageName = @"icon.png";
//        customSnsPlatform.smallImageName = @"icon.png";
//        customSnsPlatform.displayName = @"复制文本";
//        customSnsPlatform.loginName = @"复制文本";
//        customSnsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
//            NSLog(@"点击复制文本");
//        };
//    }
//    return customSnsPlatform;
//}



/*设置分享编辑页面是否等待完成之后再关闭页面还是立即关闭，如果设置成YES，就是等待分享完成之后再关闭，否则立即关闭。默认等待分享完成之后再关闭。
 */
-(BOOL)shouldShareSynchronous
{
    return YES;
}

/*设置出现的sns平台
 如果你自己设置可以参照下面的写法
*/
//- (NSArray *)shareToPlatforms
//{
//    NSArray *shareToArray = @[@[@"copy",UMShareToWechat,UMShareToWechat,UMShareToWechat,UMShareToWechat,UMShareToWechat,UMShareToSina,UMShareToQzone,UMShareToTencent,UMShareToTencent,UMShareToDouban,UMShareToRenren],@[UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter]];
//    return shareToArray;
//}
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

//设置关注的官方微博，可以设置新浪微博和腾讯微博，将会出现在授权页面下面“关注官方微博”的小勾
//-(NSDictionary *)followSnsUids
//{
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"2937537507",UMShareToSina,nil];
//    return dictionary;
//}

/*设置所有页面的背景颜色
 */
//-(UIColor *)defaultColor
//{
//    return [UIColor blueColor];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        number = [_shareToPlatformDic allKeys].count;
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
            _supportOrientationMask = UIInterfaceOrientationMaskPortrait;
        }
        else if (indexPath.row == 1){
            _supportOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
        }
        else if (indexPath.row == 2){
            _supportOrientationMask = UIInterfaceOrientationMaskLandscape;
        }
        else if (indexPath.row == 3){
            _supportOrientationMask = UIInterfaceOrientationMaskAll;
        }        
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
    }
}

@end
