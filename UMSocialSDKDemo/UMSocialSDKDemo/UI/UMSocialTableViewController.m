//
//  UMSocialTableViewController.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) umeng.com All rights reserved.
//

#import "UMSocialTableViewController.h"
#import "UMSocialTableViewCell.h"
#import "UMSocialBarViewController.h"
#import "UMSocialMacroDefine.h"

@interface UMSocialTableViewController ()

@end

@implementation UMSocialTableViewController

-(void)dealloc
{
    SAFE_ARC_RELEASE(_descriptorArray);
    //这里必须把delegate设置为nil，否则网络回调函数因为delegate被释放了会crash
    for (id key in _socialControllerDictionary) {
        UMSocialControllerService *socialController = [_socialControllerDictionary objectForKey:key];
        [socialController.socialDataService setUMSocialDelegate:nil];
    }
    SAFE_ARC_RELEASE(_socialControllerDictionary);
    SAFE_ARC_SUPER_DEALLOC();
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _descriptorArray = [[NSMutableArray alloc] init];
        _socialControllerDictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 12; i++) {
            NSString *descriptor = [NSString stringWithFormat:@"testrd%d",i];
            [_descriptorArray addObject:descriptor];
        }
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_descriptorArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SeperateCell";
    UMSocialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSString *identifierString = [_descriptorArray objectAtIndex:indexPath.row];
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:identifierString withTitle:nil];
    UMSocialControllerServiceComment *socialController = [[UMSocialControllerServiceComment alloc] initWithUMSocialData:socialData];
    SAFE_ARC_RELEASE(socialData);
    
    //放在_socialControllerDictionary 是为了离开时候把各个对象的代理设置为nil
    if ([_socialControllerDictionary objectForKey:identifierString] == nil) {
        [_socialControllerDictionary setValue:socialController forKey:identifierString];
    }
    
    if (cell == nil) {
        cell = [[UMSocialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        SAFE_ARC_AUTORELEASE(cell);
    }
    
    [socialController.socialDataService setUMSocialDelegate:cell];

    cell.socialController = socialController;
    cell.descriptor = [_descriptorArray objectAtIndex:indexPath.row];
    cell.tableViewController = self;
    SAFE_ARC_RELEASE(socialController);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMSocialTableViewCell * umSeperateCell = (UMSocialTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UMSocialBarViewController *barViewController = [[UMSocialBarViewController alloc] initWithDescriptor:[_descriptorArray objectAtIndex:indexPath.row] withText:[umSeperateCell labelText] withImage:[umSeperateCell showImage]];
    [self.navigationController pushViewController:barViewController animated:YES];
    SAFE_ARC_RELEASE(barViewController);
}

@end
