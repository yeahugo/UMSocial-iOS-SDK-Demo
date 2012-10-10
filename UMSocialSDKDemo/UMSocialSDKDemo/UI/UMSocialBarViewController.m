//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import "UMSocialBarViewController.h"
#import "WXApi.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController

-(void)dealloc
{
    [_socialBar release];
    [_textLabel release];
    [super dealloc];
}

-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image
{
    self = [super initWithNibName:@"UMSocialBarViewController" bundle:nil];
    if (self) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:descriptor];
        _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        [socialData release];
        
        [_socialBar.socialControllerService setUMSocialUIDelegate:self];
        _socialBar.socialData.shareText = text;
        _socialBar.socialData.shareImage = image;
        _socialBar.socialData.commentImage = image;
        _socialBar.socialData.commentText = text;
        [self.view addSubview:_socialBar];
        _socialBar.center = CGPointMake(160, 390);
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        _textLabel.numberOfLines = 4;
        _textLabel.text = text;
        [self.view addSubview:_textLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
        imageView.image = image;
        [self.view addSubview:imageView];
        [imageView release];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)didFinishGetUMSocialResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"response is %@",response);
}

#pragma mark - UMSocialUIDelegate

-(UITableViewCell *)customCellForShareListTableView
{
    UITableViewCell *weiXinCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weixinCell"] autorelease];
    weiXinCell.textLabel.text = @"微信分享";
    weiXinCell.imageView.image = [UIImage imageNamed:@"UMS_sms"];
    return weiXinCell;
}

-(void)didSelectShareListTableViewCell
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.text = _socialBar.socialData.shareText;
        req.scene = WXSceneSession;
        req.bText = YES;
        
        /*下面实现图片分享，只能分享文字或者分享图片，或者分享url，里面带有图片缩略图和描述文字
         WXMediaMessage * message = [WXMediaMessage message];
         WXImageObject *ext = [WXImageObject object];
         NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yinxing0" ofType:@"jpg"];
         ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
         
         message.mediaObject = ext;
         [message setThumbImage:[UIImage imageNamed:@"yinxing0"]];
         req.message = message;
         req.bText = NO;
         */
        
        [WXApi sendReq:req];
    }
    NSLog(@"分享到微信");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
