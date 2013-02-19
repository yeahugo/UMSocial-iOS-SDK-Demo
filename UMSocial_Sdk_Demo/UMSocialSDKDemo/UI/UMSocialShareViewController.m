//
//  UMSocialShareViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-22.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialShareViewController.h"
#import "UMStringMock.h"
#import "WXApi.h"
#import "UMSocialMacroDefine.h"
#import "UMSocialSnsService.h"
#import "AppDelegate.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialIconActionSheet.h"
#import "UMSocialAccountManager.h"

@interface UMSocialShareViewController ()

@end

@implementation UMSocialShareViewController

-(void)dealloc
{
    [_socialController.socialDataService setUMSocialDelegate:nil];
    SAFE_ARC_RELEASE(_socialController);
    SAFE_ARC_RELEASE(_shareTableView);
    SAFE_ARC_RELEASE(_imageView);
    SAFE_ARC_RELEASE(_locationManager);
    SAFE_ARC_RELEASE(_activityIndicatorView);
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    textLabel.numberOfLines = 4;
    textLabel.text = [UMStringMock commentMockString];
    [self.view addSubview:textLabel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,90 , 150, 120)];
    NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
    _imageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:_imageView];
    
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialSDK" withTitle:nil];
    
    socialData.shareText = textLabel.text;
    socialData.shareImage = _imageView.image;
    SAFE_ARC_RELEASE(textLabel);
    
    _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    _socialController.socialUIDelegate = self;
    SAFE_ARC_RELEASE(socialData);
    _shareTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, 320, 220)];
    _shareTableView.dataSource = self;
    _shareTableView.delegate = self;
    [self.view addSubview:_shareTableView];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 150);
    [self.view addSubview:_activityIndicatorView];
    _locationManager = [[NSClassFromString(@"CLLocationManager") alloc] init];
    [_locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SocialShareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"传统分享列表";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"新分享列表";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"分享编辑页面接口";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"直接发送到单个微博平台";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"直接发送到多个微博平台";
    }
    
    return cell;    
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //分享列表页面
    if (indexPath.row == UMShareList){

        UINavigationController *shareListController = [_socialController getSocialShareListController];
        [self presentModalViewController:shareListController animated:YES];
        /*或者用快速分享接口 */
//        [UMSocialSnsService presentSnsController:self appKey:useAppkey shareText:[UMStringMock commentMockString] shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToTencent] delegate:nil];
        
    }
    //分享编辑页面
    if (indexPath.row == UMShareEditPresent) {
        UIActionSheet * editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        editActionSheet.tag = UMShareEditPresent;
        for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
            [editActionSheet addButtonWithTitle:snsPlatform.displayName];
        }
        [editActionSheet addButtonWithTitle:@"取消"];
        editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
        [editActionSheet showFromTabBar:self.tabBarController.tabBar];
        editActionSheet.delegate = self;
        SAFE_ARC_RELEASE(editActionSheet);
    }
    //分享列表页面新样式
    else if (indexPath.row == UMShareIconActionSheet) {
        UMSocialIconActionSheet *snsIconSheet = (UMSocialIconActionSheet *)[_socialController getSocialIconActionSheetInController:self];
        [snsIconSheet showInView:self.view];

        /*或者用快速分享接口*/
//        [UMSocialSnsService presentSnsIconSheetView:self appKey:useAppkey shareText:[UMStringMock commentMockString] shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToTencent] delegate:nil];
        
    }
    //直接发送分享的数据级接口
    else if(indexPath.row == UMSharePostData){
        UIActionSheet * dataActionSheet = [[UIActionSheet alloc] initWithTitle:@"直接发送微博" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].socialSnsArray) {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
            [dataActionSheet addButtonWithTitle:snsPlatform.displayName];
        }
        [dataActionSheet addButtonWithTitle:@"取消"];
        dataActionSheet.cancelButtonIndex = dataActionSheet.numberOfButtons - 1;
        dataActionSheet.tag = UMSharePostData;
        
        [dataActionSheet showFromTabBar:self.tabBarController.tabBar];
        dataActionSheet.delegate = self;
        SAFE_ARC_RELEASE(dataActionSheet);
    }
    //一键分享到多个平台的数据级接口
    else if (indexPath.row == UMSharePostMultiData) {
        NSDictionary *socialDic =  _socialController.socialData.socialAccount;
        
        NSMutableArray *allSnsArray = [[NSMutableArray alloc] init];
        for (id type in socialDic) {
            if ([type isEqual:@"defaultAccount"] || [type isEqual:@"loginAccount"]) {
                continue;
            }
            [allSnsArray addObject:type];
        }
        unsigned int dateInteger = [[NSDate date] timeIntervalSince1970];
        int random = rand_r(&dateInteger)%10;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

        NSString *shareContent = [NSString stringWithFormat:@"%@+%d",_socialController.socialData.shareText,random];
        
        if (allSnsArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有授权账号" message:@"请先授权一个sns账号才能分享" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
            SAFE_ARC_RELEASE(alertView);
            SAFE_ARC_RELEASE(allSnsArray);
            return;
        }
        
        [_socialController.socialDataService setUMSocialDelegate:self];
        [_socialController.socialDataService postSNSWithTypes:allSnsArray  content:shareContent image:_socialController.socialData.shareImage location:nil];
        SAFE_ARC_RELEASE(allSnsArray);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    UMSocialSnsType shareToType = buttonIndex + UMSocialSnsTypeQzone;
    
    //分享编辑页面的接口
    if (actionSheet.tag == UMShareEditPresent) {
        NSString *snaName = [[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray objectAtIndex:buttonIndex];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snaName];
        
        snsPlatform.snsClickHandler(self,_socialController,YES);
    }
    //直接发送微博的数据级接口
    if (actionSheet.tag == UMSharePostData) {
        [_activityIndicatorView startAnimating];
        
        CLLocation *location = _locationManager.location;        
        NSString *dateString = [[NSDate date] description];
        NSString *shareContent = [NSString stringWithFormat:@"%@ %@",[UMStringMock commentMockString],dateString];
        [_socialController.socialDataService setUMSocialDelegate:self];
        [_socialController.socialDataService postSNSWithType:shareToType content:shareContent image:_imageView.image location:location];
        return;
    }
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"response is %@",response);
    UIAlertView *alertView;
    [_activityIndicatorView stopAnimating];
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (response.responseType == UMSResponseShareToSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是数据级的发送微博接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }
        if (response.responseType == UMSResponseShareToMutilSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是发送到多个微博平台的数据级接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }        
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"亲，您刚才调用的发送微博接口发送失败了，具体原因请看到回调方法response对象的responseCode和message~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
        SAFE_ARC_RELEASE(alertView);
    }
}

#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didCloseUIViewController with type is %d",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}

@end
