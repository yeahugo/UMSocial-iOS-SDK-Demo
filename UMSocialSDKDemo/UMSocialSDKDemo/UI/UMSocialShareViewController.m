//
//  UMSocialShareViewController.m
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-22.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import "UMSocialShareViewController.h"
#import "UMStringMock.h"

@interface UMSocialShareViewController ()

@end

@implementation UMSocialShareViewController

-(void)dealloc
{
    [_socialDataAPI release];
    [_socialController release];
    [_actionSheet release];
    [_shareTableView release];
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
        _socialDataAPI = [[UMSocialDataAPI alloc] initWithUMSocialData:socialData];
        
        _socialDataAPI.socialData.shareText = textLabel.text;
        _socialDataAPI.socialData.shareImage = _imageView.image;
        
        _socialController = [[UMSocialUIController alloc] initWithUMSocialData:socialData];
        [socialData release];
        _shareTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, 320, 250)];
        _shareTableView.dataSource = self;
        _shareTableView.delegate = self;
        [self.view addSubview:_shareTableView];
        
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"图文分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"腾讯微博",@"人人网",@"豆瓣",nil];
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
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        cell.textLabel.text = @"图文分享";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"授权";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"直接发送微博";
    }
    
    return cell;    
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [_actionSheet setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [_actionSheet showInView:self.view];
    _actionSheet.delegate = self;
    UMShareAction shareAction  = indexPath.row;
    NSLog(@"tag is %d",_actionSheet.tag);
    _actionSheet.tag = shareAction;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is %d",buttonIndex);
    UMShareToType shareToType = buttonIndex;
    if (buttonIndex >= UMShareToTypeCount) {
        return;
    }
    if (actionSheet.tag == UMSharePostData) {
        [_socialDataAPI.socialData setUMSoicalDelegate:self];
        [_socialDataAPI postSNSWithType:shareToType usid:nil content:_socialDataAPI.socialData.shareText image:_imageView.image];
        return;
    }
    
    else if(actionSheet.tag == UMShareEditPresent) {
        [_socialController.socialData setUMSoicalDelegate:nil];
        [_socialController presentShareEdit:shareToType];
    }
    else if(actionSheet.tag == UMShareOauthPresent) {
        UIViewController *oauthViewController = [UMSocialUIController getOauthViewController:shareToType];
        [self presentModalViewController:oauthViewController animated:YES];
    }
}

-(void)didFinishGetUMSocialResponse:(UMSResponseEntity *)response
{
    UIAlertView *alertView;
    if (response.responseType == UMSResponseShareToSNS) {
        if (response.st == UMSResponseCodeSuccess) {
            alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"发送成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        }
        else {
            NSString *msg = response.message;
            alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            
        }
        [alertView show];
        [alertView release];   
    }
}
@end
