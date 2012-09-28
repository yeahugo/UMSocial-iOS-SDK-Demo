//
//  UMSocialCommentViewController.m
//  SocialSDK
//
//  Created by jiahuan ye on 12-9-1.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import "UMSocialCommentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UMSocialAccountEntity.h"
#import "UMStringMock.h"

@interface UMSocialCommentViewController ()

@end

@implementation UMSocialCommentViewController

-(void)dealloc
{
    [_socialController release];
    [_commentTableView release];
    [_imageView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        textLabel.numberOfLines = 4;
        textLabel.text = [UMStringMock commentMockString];
        [self.view addSubview:textLabel];
        [textLabel release];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,90 , 150, 120)];
        NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
        _imageView.image = [UIImage imageNamed:imageName];
        [self.view addSubview:_imageView];
        
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"another"];
        _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        
        _socialController.socialDataService.socialData.commentText = textLabel.text;        //作为分享到微博内容"//"之后的文字
        _socialController.socialDataService.socialData.commentImage = _imageView.image;
        
        [socialData release];
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, 320, 250)];
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        [self.view addSubview:_commentTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
        [cell autorelease];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"评论列表";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"获取评论列表数据";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"直接发送评论";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"直接发送评论并分享到微博";
    }
    return cell;    
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UINavigationController *commentList = [_socialController getSocialCommentListController];
        [self presentModalViewController:commentList animated:YES];
    }
    if (indexPath.row == 1) {
        [_socialController.socialDataService requestCommentList:(-1)];
    }
    if (indexPath.row == 2) {
        [_socialController.socialDataService postCommentWithContent:[UMStringMock commentMockString]];
    }
    if (indexPath.row == 3) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:30.0 longitude:108.0];
        NSDictionary *snsDic = _socialController.socialDataService.socialData.socialAccount;
        NSMutableDictionary *shareToSNSDictionary = [[NSMutableDictionary alloc] init];
        for (id key in snsDic) {
            if (![key isEqualToString:@"defaultAccount"]&&![key isEqualToString:@"loginAccount"]) {
                NSLog(@"key is %@",key);
                [shareToSNSDictionary setObject:[[snsDic objectForKey:key] usid] forKey:key];
            }
        }
        [_socialController.socialDataService postCommentWithContent:[UMStringMock commentMockString] location:location shareToSNSWithUsid:shareToSNSDictionary];
        [location release];
        [shareToSNSDictionary release];
    }
}

#pragma UMSocialDelegate
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发送结果" message:@"成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    if (response.st == UMSResponseCodeSuccess) {
        [alertView show];
    }
    else
    {
        alertView.message = @"失败";
    }
    [alertView show];
    [alertView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
