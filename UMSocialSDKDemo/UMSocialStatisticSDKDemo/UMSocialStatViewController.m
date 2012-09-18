//
//  UMSocialStatViewController.m
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//

#import "UMSocialStatViewController.h"

@interface UMSocialStatViewController ()

@end

@implementation UMSocialStatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    count  = 0;
    _socialStatistic = [[UMSocialStatistic alloc] initWithIdentifier:@"test" cuid:@"123"];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
        NSString *commentString = [NSString stringWithFormat:@"test + %@",[[NSDate date] description]];
        [_socialStatistic postCommentWithContent:commentString location:nil shareToSNSWithUsid:nil];
    }
    if (indexPath.row == 1) {
        [_socialStatistic addOrMinusLikeNumber];
    }
    if (indexPath.row == 2) {
        [_socialStatistic postSNSWithType:UMShareToTypeSina usid:@"shoujigavin8783" content:@"test" weiboId:@"124305058121693"];
    }
}

#pragma mark - UMSocialDelegate
-(void)didFinishGetUMSocialResponse:(UMSResponseEntity *)response
{
    count ++;
    NSLog(@"finish getUmsoicalresponse!! count is %d",count);
    if (count == 10) {
        _sentContinue = NO;
        count = 0;
        for (int i = 0; i<3; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    if (_sentContinue == YES) {
        if (response.responseType == UMSResponseAddLike ) {
            [_socialStatistic addOrMinusLikeNumber];
        }
        if (response.responseType == UMSResponseAddComment ) {
            NSString *snsString = [NSString stringWithFormat:@"test + %@",[[NSDate date] description]];
            [_socialStatistic postCommentWithContent:snsString location:nil shareToSNSWithUsid:nil];
        }
        if (response.responseType == UMSResponseShareToSNS) {
            NSString *snsString = [NSString stringWithFormat:@"test + %@",[[NSDate date] description]];
            [_socialStatistic postSNSWithType:UMShareToTypeTenc usid:nil content:snsString weiboId:nil];
        }        
    }
}

@end
