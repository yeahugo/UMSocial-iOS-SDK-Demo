//
//  MediaPlayerDemoViewController.h
//  SocialSDK
//
//  Created by yeahugo on 13-12-11.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialShakeService.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerDemoViewController : UIViewController <UMSocialShakeDelegate>

@property (nonatomic, strong) MPMoviePlayerViewController * moviePlayerViewController;

-(IBAction)playVideo:(id)sender;
@end
