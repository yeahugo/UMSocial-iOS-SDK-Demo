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
    SAFE_ARC_BLOCK_RELEASE(_actionSheetHandler);
    SAFE_ARC_SUPER_DEALLOC();
}

-(id)initWithItems:(NSArray *)items withButtonHandler:(void (^)(UMSocialSnsType snsType))handler
{
    
    float deltaY = 100.0;
    float startX = 20.0;
    float startY = 30.0;
    float buttonWidth = 57;
    float buttonHeight = 57;
    
    int numPerRow = 4;  //如果你把numPerRow改为3，即每行显示3个，需要把startX改为25 
    
    CGRect fullFrame = [[UIApplication sharedApplication] keyWindow].bounds;
    
    float deltaX = (fullFrame.size.width - 2*startX)/numPerRow;

    float height = 70 + ceil((float)items.count/numPerRow) * deltaY;
    CGRect frame = CGRectMake(0, fullFrame.size.height - height,fullFrame.size.width ,height );
    self = [super initWithFrame:frame];
    if (self) {
        self.actionSheetHandler = handler;
        UIImage * backgroundImage = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_panel"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];

        UIImageView *actionSheetBackground = [[UIImageView alloc] initWithImage:backgroundImage];
        actionSheetBackground.image = backgroundImage;
        actionSheetBackground.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:actionSheetBackground];
        SAFE_ARC_RELEASE(actionSheetBackground);
    
        for (int i = 0 ; i < items.count ; i++) {
            NSString *snsName = items[i];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
            NSString *snsDisplayName = snsPlatform.displayName;
            
            UILabel *snsNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(startX + deltaX * (i%numPerRow) + (deltaX-buttonWidth)/2, startY + (i/numPerRow)*deltaY + 60, 55, 20)];
            snsNamelabel.textAlignment = UITextAlignmentCenter;
            [snsNamelabel setBackgroundColor:[UIColor clearColor]];
            [snsNamelabel setTextColor:[UIColor whiteColor]];
            [snsNamelabel setFont:[UIFont systemFontOfSize:12]];
            [snsNamelabel setText:snsDisplayName];
            [self addSubview:snsNamelabel];
            
            UIImage *snsImage = [UIImage imageNamed:snsPlatform.bigImageName];
            UIButton *snsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [snsButton setBackgroundImage:snsImage forState:UIControlStateNormal];
            snsButton.frame = CGRectMake(startX + deltaX * (i%numPerRow) + (deltaX-buttonWidth)/2, startY + (i/numPerRow)*deltaY , buttonWidth, buttonHeight);
            snsButton.tag = snsPlatform.shareToType;
            [snsButton addTarget:self action:@selector(actionToSnsButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:snsButton];
            SAFE_ARC_RELEASE(snsNamelabel);
        }
        
        UIImage *image = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_button"];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
        
        UIImage *selectImage = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_button_selected"];
        selectImage = [selectImage stretchableImageWithLeftCapWidth:(int)(image.size.width)>>1 topCapHeight:0];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 200, 40);
        cancelButton.center = CGPointMake(self.frame.size.width/2,frame.size.height - 30);
        [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:selectImage forState:UIControlStateSelected];
        
        [cancelButton setTitle:@"取  消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

-(void)actionToSnsButton:(UIButton *)snsButton
{
    UMSocialSnsType snsType = snsButton.tag;
    [self dismiss];
    self.actionSheetHandler(snsType);
}

-(void)showInView:(UIView *)showView
{
    if ([self superview] == nil) {
        [showView addSubview:self];
        self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height + self.frame.size.height/2);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height - self.frame.size.height/2);
                     } completion:^(BOOL finished) {
                     }];
}

-(void)dismiss
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    UIView *showView = [self superview];
    self.center = CGPointMake(showView.frame.size.width/2, showView.frame.size.height + self.frame.size.height/2);
    [UIView commitAnimations];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
