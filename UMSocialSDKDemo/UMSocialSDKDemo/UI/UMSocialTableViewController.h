//
//  UMSocialTableViewController.h
//  SocialSDK
//
//  Created by jiahuan ye on 12-8-21.
//  Copyright (c) 2012年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSocialTableViewController : UITableViewController
{
    NSMutableArray *_descriptorArray;
    int _didSelectIndex;
    NSMutableDictionary *_socialControllerDictionary;
}
@property (nonatomic) int didSelectIndex;
@end
