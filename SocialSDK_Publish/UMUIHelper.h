//
//  UMUIHelper.h
//  SocialSDK
//
//  Created by Aladdin Zhang on 5/9/12.
//  Copyright (c) 2012 innovation-works. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
  UMSCGroupedCellPositionTop=0,
  UMSCGroupedCellPositionMiddle,
  UMSCGroupedCellPositionBottom
}UMSCGroupedCellPosition;

@interface UMUIHelper : NSObject

//自定义返回的导航栏
+ (void) customNavBackButton:(UIButton *)button WithTitle:(NSString *)title;

//自定义导航栏非返回的按钮
+ (void) customNavButton:(UIButton *)button WithTitle:(NSString *)title;

//自定以取消地理位置的按钮
+ (void) customCancelLocationButton:(UIButton *) button WithTitle:(NSString *) title;

//自定义导航栏
+ (void) customNavBar:(UINavigationBar *) bar;

//自定义分享列表cell
+ (void) customShareListCell:(UITableViewCell*)cell;

//自定义分享列表选中cell
+ (void) customShareListCellSelectedLayer:(UITableViewCell*)cell
                                 position:(UMSCGroupedCellPosition)position;

@end
