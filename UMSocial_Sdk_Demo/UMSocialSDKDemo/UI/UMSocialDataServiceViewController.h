//
//  UMSocialDataServiceViewController.h
//  SocialSDK
//
//  Created by yeahugo on 13-3-7.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatform.h"

@interface UMSocialDataServiceViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UITextView *_shareTextView;
    IBOutlet UITextView *_textView;
    IBOutlet UILabel *_socialPlatformLabel;
    IBOutlet UILabel *_oauthDescriptionLabel;
    UMSocialDataService *_socialDataService;
    UIButton *_addUrlResourceButton;
    UMSocialSnsPlatform *_socialPlatform;
    UIActivityIndicatorView * _activityIndicatorView;
}

@property (nonatomic, retain) UMSocialSnsPlatform *socialPlatform;

-(IBAction)changeSocialPlatform:(id)sender;
@end
