//
//  UMSocialSnsViewController.h
//  SocialSDK
//
//  Created by yeahugo on 13-5-19.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSocialSnsViewController : UIViewController<UIActionSheetDelegate>
{
    UIActivityIndicatorView * _activityIndicatorView;
    NSDictionary *_postsDic;
    
    IBOutlet UIButton *_shareButton1;
    IBOutlet UIButton *_shareButton2;
    IBOutlet UIButton *_shareButton3;
}

@property (nonatomic, strong) NSDictionary *postsDic;

-(IBAction)showShareList1:(id)sender;

-(IBAction)showShareList2:(id)sender;

-(IBAction)showShareList3:(id)sender;

@end
