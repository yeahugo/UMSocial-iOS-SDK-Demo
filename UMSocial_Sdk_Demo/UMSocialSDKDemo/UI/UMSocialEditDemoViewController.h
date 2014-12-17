//
//  UMSocialEditDemoViewController.h
//  SocialSDK
//
//  Created by Gavin Ye on 12/17/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSocialEditDemoViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextView *shareTextView;

- (IBAction)onClickClose:(id)sender;

- (IBAction)onClickPostShare:(id)sender;

@end
