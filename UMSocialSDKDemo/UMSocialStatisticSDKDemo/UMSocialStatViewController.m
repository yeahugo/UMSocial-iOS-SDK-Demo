//
//  UMSocialStatViewController.m
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//

#import "UMSocialStatViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface UMSocialStatViewController ()

@end

@implementation UMSocialStatViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [_socialStatistic setUMSocialDelegate:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    count  = 0;
    _sentContinue = YES;
    _socialStatistic = [[UMSocialStatistic alloc] initWithIdentifier:@"test"];
    [_socialStatistic setUMSocialDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UMSocialStatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"发送评论";
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = @"添加喜欢";
    }
    else if(indexPath.row == 2){
        cell.textLabel.text = @"分享";
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _sentContinue = YES;
    if (indexPath.row == 0) {
        [self postComment];
    }
    if (indexPath.row == 1) {
        [_socialStatistic postAddLikeOrCancel];
    }
    if (indexPath.row == 2) {
        [self postSNS];
    }
}

-(void)postSNS
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:22.5 longitude:112];

    NSString *snsString = [NSString stringWithFormat:@"test + %@",[[NSDate date] description]];
    [_socialStatistic postSNSWithType:UMShareToTypeSina usid:@"shoujigavin8783" content:snsString weiboId:@"124305058121693" location:location];
    [location release];
}

-(void)postComment
{
    NSString *commentString = [NSString stringWithFormat:@"test + %@",[[NSDate date] description]];
    UIImage *image = [UIImage imageNamed:@"yinxing0.jpg"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:22.5 longitude:112];
    NSDictionary *shareToDic = [NSDictionary dictionaryWithObjectsAndKeys:@"123",UMShareToSina,nil];
    [_socialStatistic postCommentWithContent:commentString image:image templateText:@"template" location:location shareToSNSWithUsid:shareToDic];
    [location release];
}

#pragma mark - UMSocialDelegate
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    count ++;
    NSLog(@"finish getUmsoicalresponse!! count is %d",count);
    if (count == 10) {
        _sentContinue = NO;
        for (int i = 0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            count = 0;
        }
    }
    if (_sentContinue == YES) {
        if (response.responseType == UMSResponseAddLike ) {
            [_socialStatistic postAddLikeOrCancel];
        }
        if (response.responseType == UMSResponseAddComment ) {
            [self postComment];
        }
        if (response.responseType == UMSResponseShareToSNS) {
            [self postSNS];
        }        
    }
}

@end
