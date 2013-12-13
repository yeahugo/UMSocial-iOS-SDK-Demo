//
//  MediaPlayerDemoViewController.m
//  SocialSDK
//
//  Created by yeahugo on 13-12-11.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "MediaPlayerDemoViewController.h"

#import "UMSocialShakeService.h"
#import "UMSocialScreenShoter.h"


@interface MediaPlayerDemoViewController ()

@end

@implementation MediaPlayerDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//摇一摇动作的回调方法
-(UMSocialShakeConfig)didShakeWithShakeConfig
{
    //相应摇一摇后，你分享自己的播放器得到截图
//    [UMSocialShakeService setScreenShotImage:[UIImage imageNamed:@"UMS_social_demo"]];
    //暂停你的播放器
    [self.moviePlayerViewController.moviePlayer pause];
    return UMSocialShakeConfigDefault;
}

//用户分享或者关闭分享页面的回调方法
-(void)didCloseShakeView
{
    [self.moviePlayerViewController.moviePlayer play];
}

//分享完成的回调方法
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"分享成功" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    } else if(response.responseCode != UMSResponseCodeCancel) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"分享失败" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

-(IBAction)playVideo:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
    self.moviePlayerViewController = moviePlayer;
    [moviePlayer.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onActionDissmissPlayer) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
    [UMSocialShakeService setShakeToShareWithTypes:nil shareText:shareText screenShoter:[UMSocialScreenShoterMediaPlayer screenShoterFromMoviePlayer:moviePlayer.moviePlayer] inViewController:moviePlayer delegate:self];
}

//当你退出播放器后解除监听摇一摇事件
-(void)onActionDissmissPlayer
{
    [UMSocialShakeService unShakeToSns];
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
