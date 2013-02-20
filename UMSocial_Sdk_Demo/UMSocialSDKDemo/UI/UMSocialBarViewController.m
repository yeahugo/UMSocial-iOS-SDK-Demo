//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialBarViewController.h"
#import "WXApi.h"
#import "UMSocialMacroDefine.h"
#import "UMStringMock.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController

-(void)dealloc
{
    SAFE_ARC_RELEASE(_socialBar);
    SAFE_ARC_RELEASE(_textLabel);
    _socialBar.socialBarDelegate = nil;
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)init
{
    NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
    UIImage *image = [UIImage imageNamed:imageName];
    return [self initWithDescriptor:@"test" withText:[UMStringMock commentMockString] withImage:image];
}


-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image
{
    self = [super initWithNibName:@"UMSocialBarViewController" bundle:nil];
    if (self) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:descriptor withTitle:@"socialBarTest"];
        _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        _socialBar.socialBarDelegate = self;
//        _socialBar.socialBarView.themeColor = UMSBarColorWhite;
        SAFE_ARC_RELEASE(socialData);
        
        _socialBar.socialData.shareText = text;
        _socialBar.socialData.shareImage = image;
        _socialBar.socialData.commentImage = image;
        _socialBar.socialData.commentText = text;
        [self.view addSubview:_socialBar];
        CGRect rect = [[UIApplication sharedApplication] keyWindow].bounds;
        _socialBar.center = CGPointMake(160, rect.size.height - 94);
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        _textLabel.numberOfLines = 4;
        _textLabel.text = text;
        [self.view addSubview:_textLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, 320, 200)];
        imageView.image = image;
        [self.view addSubview:imageView];
        SAFE_ARC_RELEASE(imageView);
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
    [_socialBar.socialControllerService.socialDataService requestSocialData];
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

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}

#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}

@end
