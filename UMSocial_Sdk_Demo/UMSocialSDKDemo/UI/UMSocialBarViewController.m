//
//  UMSocialBarViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialBarViewController.h"
#import "AppDelegate.h"

@interface UMSocialBarViewController ()

@end

@implementation UMSocialBarViewController

- (void)viewDidLoad
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);
    
    _socialBar = [[UMSocialBar alloc] initWithUMSocialData:[UMSocialData defaultData] withViewController:self];
    _socialBar.socialBarDelegate = self;

    _socialBar.center = CGPointMake(size.width/2, size.height - 93);
    [self.view addSubview:_socialBar];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)comment:(id)sender
{
    UINavigationController *navigationController = [[UMSocialControllerServiceComment defaultControllerService] getSocialCommentListController];
    [self presentModalViewController:navigationController animated:YES];
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    CGSize size = [UIScreen mainScreen].bounds.size;
    size = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? size : CGSizeMake(size.height, size.width);
    float barHeight = 44;
    _socialBar.center = CGPointMake(size.height/2, size.width - 44 - barHeight - _socialBar.frame.size.height );
    
    _webView.frame = CGRectMake(0, 0, size.height, size.width - 44 - barHeight - _socialBar.frame.size.height);
}

#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}

@end
