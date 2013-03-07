//
//  UMSocialDataServiceViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-3-7.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialDataServiceViewController.h"
#import "UMSocialMacroDefine.h"

@interface UMSocialDataServiceViewController ()

@end

@implementation UMSocialDataServiceViewController

-(void)viewDidLoad
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _socialDataService = [[UMSocialDataService alloc] initWithUMSocialData:[UMSocialData defaultData]];
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialDataServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        SAFE_ARC_AUTORELEASE(cell);
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"获取数据";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"个人中心";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"登录信息";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"登录";
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = @"授权";
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = @"解除登录";
    }
    if (indexPath.row == 6) {
        cell.textLabel.text = @"添加自有账号";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [_socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response){
            _textView.text = [response description];
            NSLog(@"response is %@",response);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
