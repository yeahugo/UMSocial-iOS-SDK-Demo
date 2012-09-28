//
//  UMSocialStatViewController.h
//  SocialSDK
//
//  Created by yeahugo on 12-9-13.
//
//

#import <UIKit/UIKit.h>
#import "UMSocialStatistic.h"

@interface UMSocialStatViewController : UITableViewController<UMSocialDataDelegate>
{
    UMSocialStatistic *_socialStatistic;
    int count;
    BOOL _sentContinue;
}
@end
