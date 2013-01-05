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
#import <MessageUI/MessageUI.h>
#import "UMSocialMacroDefine.h"

@interface UMSocialShareViewController ()

@end

@implementation UMSocialShareViewController

-(void)dealloc
{
    [_socialController.socialDataService setUMSocialDelegate:nil];
    SAFE_ARC_RELEASE(_socialController);
    SAFE_ARC_RELEASE(_editActionSheet);
    SAFE_ARC_RELEASE(_dataActionSheet);
    SAFE_ARC_RELEASE(_shareTableView);
    SAFE_ARC_RELEASE(_imageView);
    SAFE_ARC_RELEASE(_locationManager);
    SAFE_ARC_RELEASE(_activityIndicatorView);
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        _socialController.soicalUIDelegate = self;
        SAFE_ARC_RELEASE(socialData);
        _shareTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, 320, 250)];
        _shareTableView.dataSource = self;
        _shareTableView.delegate = self;
        [self.view addSubview:_shareTableView];
        
        _editActionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"QQ空间",@"新浪微博",@"腾讯微博",@"人人网",@"豆瓣",@"邮箱分享",@"短信分享",nil];
        _editActionSheet.tag = UMShareEditPresent;
        _dataActionSheet = [[UIActionSheet alloc] initWithTitle:@"直接发送微博" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"QQ空间",@"新浪微博",@"腾讯微博",@"人人网",@"豆瓣",nil];
        _dataActionSheet.tag = UMSharePostData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(160, 150);
    [self.view addSubview:_activityIndicatorView];
    _locationManager = [[CLLocationManager alloc] init];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
        cell.textLabel.text = @"分享列表";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"图文分享";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"直接发送到单个微博平台";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"直接发送到多个微博平台";
    }
    
    return cell;    
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == UMShareEditPresent) {
        [_editActionSheet showInView:self.view];
        _editActionSheet.delegate = self;
    }
    else if(indexPath.row == UMSharePostData){
        [_dataActionSheet showInView:self.view];
        _dataActionSheet.delegate = self;
    }
    else if (indexPath.row == UMSharePostMultiData) {
        [_activityIndicatorView startAnimating];
        
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
        CLLocation *location = [[CLLocation alloc] initWithLatitude:28+random longitude:107+random];

        NSString *shareContent = [NSString stringWithFormat:@"%@+%d",_socialController.socialData.shareText,random];
        
        [_socialController.socialDataService setUMSocialDelegate:self];
        [_socialController.socialDataService postSNSWithType:allSnsArray usids:nil  content:shareContent image:_socialController.socialData.shareImage location:location];
        SAFE_ARC_RELEASE(location);
        SAFE_ARC_RELEASE(allSnsArray);
    }
    else{
         UINavigationController *shareListController = [_socialController getSocialShareListController];
        [self presentModalViewController:shareListController animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is %d",buttonIndex);
    UMSocialSnsType shareToType = buttonIndex + UMSocialSnsTypeQzone;
    if (shareToType >= UMSocialSnsTypeCount) {
        if (actionSheet.tag == UMShareEditPresent) {
            shareToType = shareToType + 1;
            if (shareToType == UMSocialSnsTypeSms && ![MFMessageComposeViewController canSendText]) {
                UIAlertView * servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [servicesDisabledAlert show];
                SAFE_ARC_RELEASE(servicesDisabledAlert);
            }
            if (shareToType == UMSocialSnsTypeEmail && ![MFMailComposeViewController canSendMail]) {
                UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"邮件功能未开启" message:@"您当前设备的邮件服务处于未启用状态，若想通过邮件分享，请到设置中设置邮件服务后，再进行分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [servicesDisabledAlert show];
                SAFE_ARC_RELEASE(servicesDisabledAlert);
            }
            else if(shareToType <= UMSocialSnsTypeSms){
                UINavigationController *shareEditController = [_socialController getSocialShareEditController:shareToType];
                if (shareEditController != nil) {
                    [self presentModalViewController:shareEditController animated:YES];
                }            
            }
        }
        return;
    }
    if (actionSheet.tag == UMSharePostData) {
        [_activityIndicatorView startAnimating];
        
        CLLocation *location = _locationManager.location;
        NSLog(@"location is %@",location);
        
        NSString *dateString = [[NSDate date] description];
        NSString *shareContent = [NSString stringWithFormat:@"%@ %@",[UMStringMock commentMockString],dateString];
        [_socialController.socialDataService setUMSocialDelegate:self];
        [_socialController.socialDataService postSNSWithType:shareToType usid:nil content:shareContent image:_imageView.image location:location];
        return;
    }
    else if(actionSheet.tag == UMShareEditPresent) {
        UINavigationController *shareEditController = [_socialController getSocialShareEditController:shareToType];
        [self presentModalViewController:shareEditController animated:YES];
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
