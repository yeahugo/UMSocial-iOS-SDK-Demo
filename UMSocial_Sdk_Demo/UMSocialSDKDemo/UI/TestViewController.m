//
//  TestViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-7-4.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "TestViewController.h"
#import "UMSocial.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)onClickShowSns:(id)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"" shareText:@"123" shareImage:nil shareToSnsNames:nil delegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
