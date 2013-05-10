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

#define kTagPageController 1000

@implementation UMSocialIconActionSheet

@synthesize actionSheetHandler = _actionSheetHandler;

-(void)dealloc
{
    SAFE_ARC_RELEASE(_snsNames);
    SAFE_ARC_BLOCK_RELEASE(_actionSheetHandler);
    SAFE_ARC_RELEASE(_backgroundImageView);
    SAFE_ARC_RELEASE(_actionSheetBackground);
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
    CGPoint startPoint = CGPointMake(20, 25);
    CGSize buttonSize = CGSizeMake(57, 57);
    CGSize labelSize = CGSizeMake(55, 20);
    float actionSheetHeight = 400;
    
    float buttomHeight = 70 + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    int numPerRow = 3;  
  
    CGRect fullFrame = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        fullFrame.size = CGSizeMake(fullFrame.size.height, fullFrame.size.width);
        buttomHeight = 70 + [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    
    float deltaX = (fullFrame.size.width - 2*startPoint.x)/numPerRow;
    
    float height = buttomHeight + ceil((float)self.snsNames.count/numPerRow) * deltaY;
    float width  = fullFrame.size.width;
    
    //处理iPhone5横屏的时候，自己的高度有可能超出屏幕高度
    int numPerPage = self.snsNames.count;
    
    int maxRowNum = UIInterfaceOrientationIsPortrait(orientation) ? 3 : 2;
    
    while (height > fullFrame.size.height || height > actionSheetHeight) {
        numPerRow ++;
        deltaX = (fullFrame.size.width - 2*startPoint.x)/numPerRow;
        height = buttomHeight  + ceil((float)self.snsNames.count/numPerRow) * deltaY;
        if (deltaX <  70) {
            width =  2 * width;
            height = (actionSheetHeight < fullFrame.size.height ) ? actionSheetHeight : (fullFrame.size.height );
            numPerRow --;
            deltaX = 70;
            numPerPage = numPerRow * maxRowNum;
            break;
        }
    }
    
    CGRect frame = CGRectMake(0, fullFrame.size.height - height,fullFrame.size.width,height);
    self.frame = frame;
    
    if (self.superview != nil) {
        UIView *backGroundView = self.superview;
        backGroundView.frame = fullFrame;
    }
    
    if (_actionSheetBackground == nil) {
        UIImage * backgroundImage = [UIImage imageNamed:@"UMSocialSDKResources.bundle/UMS_actionsheet_panel"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        _backgroundImageView.frame = CGRectMake(0, 0, width, height);
        _actionSheetBackground = [[UIScrollView alloc] initWithFrame:frame];
        _actionSheetBackground.showsHorizontalScrollIndicator = YES;
        _actionSheetBackground.contentSize = CGSizeMake(width, height);
        _actionSheetBackground.pagingEnabled = YES;
        _actionSheetBackground.scrollEnabled = YES;
        _actionSheetBackground.delegate = self;
        _actionSheetBackground.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [_actionSheetBackground addSubview:_backgroundImageView];
        _actionSheetBackground.frame = CGRectMake(0, 0, fullFrame.size.width, fullFrame.size.height);
        [self addSubview:_actionSheetBackground];
        
    }
    else{
        _actionSheetBackground.frame = CGRectMake(0, 0, fullFrame.size.width, fullFrame.size.height);
        _actionSheetBackground.contentSize = CGSizeMake(width, height);
        _backgroundImageView.frame = CGRectMake(0, 0, width, height);
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
        [_cancelButton addTarget:self action:@selector(dismiss)  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        if (width == 2 * fullFrame.size.width) {
            UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(fullFrame.size.width/2 - 50, height - 140, 100, 30)];
            _cancelButton.center = CGPointMake(self.frame.size.width/2,self.frame.size.height - buttomHeight + _cancelButton.frame.size.height + 10);
            pageController.numberOfPages = 2;
            pageController.currentPage = 0;
            pageController.tag = kTagPageController;
            [_actionSheetBackground.superview addSubview:pageController];
            SAFE_ARC_RELEASE(pageController);
        }
    }
    else{
        _cancelButton.center = CGPointMake(self.frame.size.width/2,self.frame.size.height - buttomHeight + _cancelButton.frame.size.height + 5);
        if (width == 2 * fullFrame.size.width) {
            UIPageControl *pageController = (UIPageControl *)[_actionSheetBackground.superview viewWithTag:1000];
            pageController.center = CGPointMake(_cancelButton.center.x, _cancelButton.center.y - 30);
        }
    }
    
    for (int i = 0 ; i < self.snsNames.count ; i++) {
        NSString *snsName = [self.snsNames objectAtIndex:i];
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
        NSString *snsDisplayName = snsPlatform.displayName;
        
        UILabel *snsNamelabel = (UILabel *)[self viewWithTag:snsPlatform.shareToType];
        CGRect labelRect = CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-buttonSize.width)/2 + (i/numPerPage) * self.frame.size.width, buttonSize.height + startPoint.y + ((i%numPerPage)/numPerRow)*deltaY, labelSize.width, labelSize.height);
        if (snsNamelabel == nil) {
            UILabel *snsNamelabel = [[UILabel alloc] initWithFrame:labelRect];
            snsNamelabel.tag = snsPlatform.shareToType;
            #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            snsNamelabel.textAlignment = UITextAlignmentCenter;
            #pragma GCC diagnostic warning "-Wdeprecated-declarations"
            [snsNamelabel setBackgroundColor:[UIColor clearColor]];
            [snsNamelabel setTextColor:[UIColor whiteColor]];
            [snsNamelabel setFont:[UIFont systemFontOfSize:12]];
            [snsNamelabel setText:snsDisplayName];
            [_actionSheetBackground addSubview:snsNamelabel];
            SAFE_ARC_RELEASE(snsNamelabel);
        }
        else{
            snsNamelabel.frame = labelRect;
        }
        UIButton *snsButton = (UIButton *)[self viewWithTag:snsPlatform.shareToType + 100];
        CGRect buttonRect = CGRectMake(startPoint.x + deltaX * (i%numPerRow) + (deltaX-buttonSize.width)/2 + (i/numPerPage) * self.frame.size.width, startPoint.y + ((i%numPerPage)/numPerRow)*deltaY , buttonSize.width, buttonSize.height);
        if (snsButton == nil) {
            UIButton *snsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *snsImage = [UIImage imageNamed:snsPlatform.bigImageName];
            [snsButton setBackgroundImage:snsImage forState:UIControlStateNormal];
            snsButton.frame = buttonRect;
            snsButton.tag = snsPlatform.shareToType + 100;
            [snsButton addTarget:self action:@selector(actionToSnsButton:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetBackground addSubview:snsButton];
        }
        else{
            snsButton.frame = buttonRect;
        }
    }
    
    [super drawRect:self.frame];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page == 1) {
        UIPageControl * pageControler = (UIPageControl *)[_actionSheetBackground.superview viewWithTag:kTagPageController];
        pageControler.currentPage = 1;
    }
    else if (page == 0)
    {
        UIPageControl * pageControler = (UIPageControl *)[_actionSheetBackground.superview viewWithTag:kTagPageController];
        pageControler.currentPage = 0;
    }
}

-(void)actionToSnsButton:(UIButton *)snsButton
{
    UMSocialSnsType snsType = snsButton.tag - 100;
    [self dismiss];
    self.actionSheetHandler([UMSocialSnsPlatformManager getSnsPlatformString:snsType]);
}

-(void)showInView:(UIView *)showView
{
    CGRect fullFrame = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        fullFrame.size = CGSizeMake(fullFrame.size.height, fullFrame.size.width);
    }
    
    if ([self superview] == nil) {
        [showView.window addSubview:self];
        self.center = CGPointMake(fullFrame.size.width/2, fullFrame.size.height + fullFrame.size.height/2 );
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
                         self.center = CGPointMake(fullFrame.size.width/2, fullFrame.size.height - fullFrame.size.height/2 );
                     } completion:^(BOOL finished) {
                     }];
}

-(void)dismiss
{
    CGRect fullFrame = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        fullFrame.size = CGSizeMake(fullFrame.size.height, fullFrame.size.width);
    }

    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.center = CGPointMake(fullFrame.size.width/2, fullFrame.size.height + self.frame.size.height/2);
    } completion:^(BOOL finished){
        [self.superview removeFromSuperview];
        self.dismissCompletion();
    }];
}
@end
