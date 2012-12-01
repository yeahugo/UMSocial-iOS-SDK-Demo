//
//  UMSocialShareViewController.m
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-22.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import "UMSocialShareViewController.h"
#import "UMStringMock.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>

@interface UMSocialShareViewController ()

@end

@implementation UMSocialShareViewController



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
        
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"another"];
        
        socialData.shareText = textLabel.text;
        socialData.shareImage = _imageView.image;
        
        _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        _socialController.soicalUIDelegate = self;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ([_socialController.socialDataService.socialDataDelegate isEqual:self]) {
        [_socialController.socialDataService setUMSocialDelegate:nil];
    }
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
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"分享列表";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"图文分享";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"直接发送微博";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"直接发送到多个微博";
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

    else if(indexPath.row == UMSharePostMultiData){
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
        
        if (allSnsArray.count != 0) {
            [_socialController.socialDataService postSNSWithType:allSnsArray usids:nil  content:shareContent image:_socialController.socialData.shareImage location:location];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有授权sns账号" message:@"请先授权一个sns账号" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else{
        //用局部变量的方式，你也可以用_socialController来得到分享列表
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"test123"];
        socialData.shareText = _socialController.socialDataService.socialData.shareText;
        socialData.shareImage = _socialController.socialDataService.socialData.shareImage;
        UMSocialControllerService *socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        socialControllerService.soicalUIDelegate = self;
         UINavigationController *shareListController = [socialControllerService getSocialShareListController];
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
            }
            if (shareToType == UMSocialSnsTypeEmail && ![MFMailComposeViewController canSendMail]) {
                UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"邮件功能未开启" message:@"您当前设备的邮件服务处于未启用状态，若想通过邮件分享，请到设置中设置邮件服务后，再进行分享" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [servicesDisabledAlert show];
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
        //        unsigned int dateInteger = [[NSDate date] timeIntervalSince1970];
        //        int random = rand_r(&dateInteger)%10;
        
        CLLocation *location = _locationManager.location;
        NSLog(@"location is %@",location);
        
        //        CLLocation *location = [[CLLocation alloc] initWithLatitude:28+random longitude:107+random];
        NSString *dateString = [[NSDate date] description];
        NSString *shareContent = [NSString stringWithFormat:@"%@ %@",[UMStringMock commentMockString],dateString];
        [_socialController.socialDataService postSNSWithType:shareToType usid:nil content:shareContent image:_imageView.image location:location];
        //        [location release];
        return;
    }
    else if(actionSheet.tag == UMShareEditPresent) {
        [_socialController.socialDataService setUMSocialDelegate:self];
        _socialController.soicalUIDelegate = self;
        UINavigationController *shareEditController = [_socialController getSocialShareEditController:shareToType];
        [self presentModalViewController:shareEditController animated:YES];
    }
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    UIAlertView *alertView;
    if (response.responseType == UMSResponseShareToSNS) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"发送成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        }
        else {
            NSString *msg = response.message;
            alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            
        }
        [alertView show];
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
