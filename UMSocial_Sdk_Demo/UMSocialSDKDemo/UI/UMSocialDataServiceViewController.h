//
//  UMSocialDataServiceViewController.h
//  SocialSDK
//
//  Created by yeahugo on 13-3-7.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialDataService.h"

@interface UMSocialDataServiceViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    UMSocialDataService *_socialDataService;
    IBOutlet UITextView *_textView;
}
@end
