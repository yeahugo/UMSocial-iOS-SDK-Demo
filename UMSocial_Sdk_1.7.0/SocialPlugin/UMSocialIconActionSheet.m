//
//  UMSocialIconActionSheet.m
//  SocialSDK
//
//  Created by yeahugo on 13-1-11.
//  Copyright (c) 2013年 Umeng. All rights reserved.
//

#import "UMSocialIconActionSheet.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialMacroDefine.h"

@implementation UMSocialIconActionSheet

@synthesize actionSheetHandler = _actionSheetHandler;

-(void)dealloc
{
    SAFE_ARC_RELEASE(_snsNames);
    SAFE_ARC_BLOCK_RELEASE(_actionSheetHandler);
    SAFE_ARC_SUPER_DEALLOC();
}

-(id)initWithItems:(NSArray *)items withButtonHandler:(void (^)(NSString * platformType))handler
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.snsNames = items;
        self.actionSheetHandler = handler;
        _actionSheetBackground = nil;
        _cancelButton = nil;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    float deltaY = 85.0;
    CGPoint startPoint = CGPointMake(20, 20);
    CGSize buttonSize = CGSizeMake(57, 57);
    CGSize labelSize = CGSizeMake(55, 20);
    float actionSheetHeight = 480;
    
    float buttomHeight = 130 + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    int numPerRow = 3;  
  
    CGRect fullFrame = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        fullFrame.size = CGSizeMake(fullFrame.size.height, fullFrame.size.width);
        buttomHeight = 130 + [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    
    float deltaX = (fullFrame.size.width - 2*startPoint.x)/numPerRow;
    
    float height = buttomHeight + ceil((float)self.snsNames.count/numPerRow) * deltaY;
 
    //处理iPhone5横屏的时候，自己的高度有可能超出屏幕高度
    while (height > fullFrame.size.height || height > actionSheetHeight) {
        numPerRow ++;
        deltaX = (fullFrame.size.width - 2*startPoint.x)/numPerRow;
        height = buttomHeight  + ceil((float)self.snsNames.count/numPerRow) * deltaY;
    }
    
    CGRect frame = CGRectMake(0, fullFrame.size.height - height,fullFrame.size.width ,height);
    self.frame = frame;
    
    if (self.superview != nil) {
        UIView *backGroundView = self.superview;
        backGroundView.frame = fullFrame;
    }
    
    if (_actionSheetBackground == nil) {
        UIImage * backgroundImage = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_panel"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];

        _actionSheetBackground = [[UIImageView alloc] initWithImage:backgroundImage];
        _actionSheetBackground.image = backgroundImage;
        _actionSheetBackground.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_actionSheetBackground];
        SAFE_ARC_RELEASE(_actionSheetBackground);
    }
    else{
        _actionSheetBackground.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    if (_cancelButton == nil) {
        UIImage *image = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_button"];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
        
        UIImage *selectImage = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_button_selected"];
        selectImage = [selectImage stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];

        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 200, 40);
        _cancelButton.center = CGPointMake(self.frame.size.width/2,self.frame.size.height - buttomHeight + _cancelButton.frame.size.height);
        [_cancelButton setBackgroundImage:image forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:selectImage forState:UIControlStateSelected];
        
        [_cancelButton setTitle:@"取  消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    else{
        _cancelButton.center = CGPointMake(self.frame.size.width/2,self.frame.size.height - buttomHeight + _cancelButton.frame.size.height);
    }
    
    for (int i = 0 ; i < self.snsNames.count ; i++) {
        NSString *snsName = self.snsNames[i];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        NSString *snsDisplayName = snsPlatform.displayName;
        
        UILabel *snsNamelabel = (UILabel *)[self viewWithTag:snsPlatform.shareToType];
        if (snsNamelabel == nil) {
            UILabel *snsNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-buttonSize.width)/2, buttonSize.height + startPoint.y + (i/numPerRow)*deltaY, labelSize.width, labelSize.height)];
            snsNamelabel.tag = snsPlatform.shareToType;
            snsNamelabel.textAlignment = UITextAlignmentCenter;
            [snsNamelabel setBackgroundColor:[UIColor clearColor]];
            [snsNamelabel setTextColor:[UIColor whiteColor]];
            [snsNamelabel setFont:[UIFont systemFontOfSize:12]];
            [snsNamelabel setText:snsDisplayName];
            [self addSubview:snsNamelabel];
            SAFE_ARC_RELEASE(snsNamelabel);
        }
        else{
            snsNamelabel.frame = CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-labelSize.width)/2, buttonSize.height + startPoint.y + (i/numPerRow)*deltaY , labelSize.width, labelSize.height);
        }
        
        UIButton *snsButton = (UIButton *)[self viewWithTag:snsPlatform.shareToType + 100];
        if (snsButton == nil) {
            UIButton *snsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *snsImage = [UIImage imageNamed:snsPlatform.bigImageName];
            [snsButton setBackgroundImage:snsImage forState:UIControlStateNormal];
            snsButton.frame = CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-buttonSize.width)/2, startPoint.y + (i/numPerRow)*deltaY , buttonSize.width, buttonSize.height);
            snsButton.tag = snsPlatform.shareToType + 100;
            [snsButton addTarget:self action:@selector(actionToSnsButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:snsButton];
        }
        else{
            snsButton.frame = CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-buttonSize.width)/2, startPoint.y + (i/numPerRow)*deltaY , buttonSize.width, buttonSize.height);
        }
    }
    
    [super drawRect:self.frame];
}

-(void)actionToSnsButton:(UIButton *)snsButton
{
    UMSocialSnsType snsType = snsButton.tag - 100;
    [self dismiss];
    self.actionSheetHandler([UMSocialSnsPlatformManager getSnsPlatformString:snsType]);
}

-(void)showInView:(UIView *)showView
{
    if ([self superview] == nil) {
        [showView addSubview:self];
        self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height + self.frame.size.height/2 );
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.superview.frame];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.8;
        [backgroundView addSubview:self];
        [showView addSubview:backgroundView];
        SAFE_ARC_RELEASE(backgroundView);
    }
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height - self.frame.size.height/2 );
                     } completion:^(BOOL finished) {
                     }];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        UIView *showView = [[self superview] superview];
        self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height + self.frame.size.height/2);
    } completion:^(BOOL finished){
        [self.superview removeFromSuperview];
    }];
}
@end
