//
//  UMSocialEditDemoViewController.m
//  SocialSDK
//
//  Created by Gavin Ye on 12/17/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMSocialEditDemoViewController.h"
#import "UMSocial.h"

@interface UMSocialEditDemoViewController ()

@end

@implementation UMSocialEditDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onClickPostShare:(id)sender
{
    //这里你可以把分享平台UMShareToSina换成其他平台
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:self.shareTextView.text image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
