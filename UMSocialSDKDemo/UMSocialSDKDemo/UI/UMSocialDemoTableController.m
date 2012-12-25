//
//  UMSocialDemoTableViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialDemoTableController.h"
#import "UMSocialBarViewController.h"
#import "UMSocialTableViewController.h"
#import "UMSocialShareViewController.h"
#import "UMSocialCommentViewController.h"
#import "UMStringMock.h"
#import "UMSocialAccountViewController.h"
#import "UMSocialMacroDefine.h"

@interface UMSocialDemoTableController ()

@end

@implementation UMSocialDemoTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SocialDemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"操作栏";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"操作栏分拆接口";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"分享微博接口";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"评论接口";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"个人账号接口";
    }
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *pushedViewController = nil;

    if (indexPath.row == 0) {
        NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
        UMSocialBarViewController *barViewController = [[UMSocialBarViewController alloc] initWithDescriptor:@"test" withText:[UMStringMock commentMockString] withImage:[UIImage imageNamed:imageName]] ;
        SAFE_ARC_AUTORELEASE(barViewController);
        pushedViewController = barViewController;
    }
    if(indexPath.row == 1){
        UMSocialTableViewController *separateViewController = [[UMSocialTableViewController alloc] init];
        SAFE_ARC_AUTORELEASE(separateViewController);
        pushedViewController = separateViewController;
    }
    if (indexPath.row == 2) {
        UMSocialShareViewController *socialShareViewController = [[UMSocialShareViewController alloc] initWithNibName:@"UMSocialShareViewController" bundle:nil];
        SAFE_ARC_AUTORELEASE(socialShareViewController);
        pushedViewController = socialShareViewController;
    }
    if (indexPath.row == 3) {
        UIViewController *commentViewController = [[UMSocialCommentViewController alloc] init] ;
        SAFE_ARC_AUTORELEASE(commentViewController);
        pushedViewController = commentViewController;
    }
    if (indexPath.row == 4) {
        UMSocialAccountViewController *socialAccountViewController = [[UMSocialAccountViewController alloc] initWithStyle:UITableViewStylePlain];
        SAFE_ARC_AUTORELEASE(socialAccountViewController);
        pushedViewController = socialAccountViewController;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:pushedViewController animated:YES];
}
@end
