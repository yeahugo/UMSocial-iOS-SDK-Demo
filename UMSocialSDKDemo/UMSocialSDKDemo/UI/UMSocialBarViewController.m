//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import "UMSocialBarViewController.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController


-(id)initWithDescriptor:(NSString *)descriptor withText:(NSString *)text withImage:(UIImage *)image
{
    self = [super initWithNibName:@"UMSocialBarViewController" bundle:nil];
    if (self) {
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:descriptor withTitle:@"socialSDKTitle"];
        _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        _socialBar.socialBarDelegate = self;
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

-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"didFinishUpdateBarNumber is %d",actionTypeMask);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
