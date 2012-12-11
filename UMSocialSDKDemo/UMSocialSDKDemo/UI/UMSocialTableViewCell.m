//
//  UMSocialTableViewCell.m
//  SocialSDK
//
//  Created by Jiahuan Ye on 12-8-21.
//  Copyright (c) 2012年 Umeng. All rights reserved.
//

#import "UMSocialTableViewCell.h"
#import "UMStringMock.h"

@implementation UMSocialTableViewCell

@synthesize descriptor = _descriptor;
@synthesize tableViewController =_tabelViewController;
@synthesize socialController = _socialController;
@synthesize index = _index;


-(NSString *)labelText
{
    return _detailLabel.text;
}

-(UIImage *)showImage
{
    return _detailImageView.image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _detailLabel.numberOfLines = 4;
        _detailLabel.text = [UMStringMock shortDescriptionMockString];
        [self addSubview:_detailLabel];
        
        _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 150, 110)];
        NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
        _detailImageView.image = [UIImage imageNamed:imageName];
        [self addSubview:_detailImageView];

        
        float yPosition = 170;
        CGSize buttonSize = CGSizeMake(100, 30);
        _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _likeButton.frame = CGRectMake(0, yPosition, buttonSize.width, buttonSize.height);
        [_likeButton addTarget:self action:@selector(addLike) forControlEvents:UIControlEventTouchUpInside];
        
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _shareButton.frame = CGRectMake(120,yPosition, buttonSize.width, buttonSize.height); 
        [_shareButton addTarget:self action:@selector(pushShareList) forControlEvents:UIControlEventTouchUpInside];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _commentButton.frame = CGRectMake(230, yPosition, buttonSize.width, buttonSize.height);
        [_commentButton addTarget:self action:@selector(pushCommentList) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_likeButton];
        [self addSubview:_shareButton];
        [self addSubview:_commentButton];
        
        _socialController = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    NSLog(@"self.descriptor is %@",self.descriptor);

    NSString *likeText = [NSString stringWithFormat:@"喜欢 %d",[_socialController.socialDataService.socialData getNumber:UMSNumberLike]];
    [_likeButton setTitle:likeText forState:UIControlStateNormal];
    NSString *shareText = [NSString stringWithFormat:@"分享 %d",[_socialController.socialDataService.socialData getNumber:UMSNumberShare]];
    [_shareButton setTitle:shareText forState:UIControlStateNormal];
    NSString *commentText = [NSString stringWithFormat:@"评论 %d",[_socialController.socialDataService.socialData getNumber:UMSNumberComment]];
    NSLog(@"commment text is %@",commentText);
    [_commentButton setTitle:commentText forState:UIControlStateNormal];
    [self changeLikeButtonImage];
    NSLog(@"_detailLabel.text is %@",_detailLabel.text);
    _socialController.socialDataService.socialData.shareText = _detailLabel.text;
    NSLog(@"share text is %@",_socialController.socialDataService.socialData.shareText);
    _socialController.socialDataService.socialData.shareImage = _detailImageView.image;
    [super layoutSubviews];
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    if (response.responseType == UMSResponseGetSocialData) {
        [self handleGetSocilaInformation:response];
    }
    else if (response.responseType == UMSResponseAddLike)
    {
        [self handleAddLike:response];
    }
}

-(void)handleGetSocilaInformation:(UMSocialResponseEntity *)response
{
    NSLog(@"socialbar's descriptor is %@",_socialController.socialDataService.socialData.identifier);
    NSLog(@"socialbar is %@",[_socialController description]);
    int likeNum = [_socialController.socialDataService.socialData getNumber:UMSNumberLike];
    int shareNum = [_socialController.socialDataService.socialData getNumber:UMSNumberShare];
    int commentNum = [_socialController.socialDataService.socialData getNumber:UMSNumberComment];
    NSString *likeText = [NSString stringWithFormat:@"喜欢 %d",likeNum];
    [_likeButton setTitle:likeText forState:UIControlStateNormal];
    NSString *shareText = [NSString stringWithFormat:@"分享 %d",shareNum];
    [_shareButton setTitle:shareText forState:UIControlStateNormal];
    NSString *commentText = [NSString stringWithFormat:@"评论 %d",commentNum];
    [_commentButton setTitle:commentText forState:UIControlStateNormal];
    NSLog(@"response is %@",[response description]);
    [self changeLikeButtonImage];
}

-(void)handleAddLike:(UMSocialResponseEntity *)response
{
    int st = response.responseCode;
    if (st == UMSResponseCodeSuccess) {
        [_likeButton setEnabled:YES];
        int likeNum = [_socialController.socialDataService.socialData getNumber:UMSNumberLike];
        NSString *likeText = [NSString stringWithFormat:@"喜欢 %d",likeNum];
        [_likeButton setTitle:likeText forState:UIControlStateNormal];
        [self changeLikeButtonImage];
    }
}

-(void)addLike
{
    [_likeButton setEnabled:NO];
    [_socialController.socialDataService setUMSocialDelegate:self];
    [_socialController.socialDataService postAddLikeOrCancel];
}


- (void) changeLikeButtonImage
{
    UIImage *bgImage = nil;
    UIImage *hlImage = nil;
    if (_socialController.socialDataService.socialData.isLike == NO) {
        bgImage = [UIImage imageNamed:@"UMS_like_off.png"];
        hlImage = [UIImage imageNamed:@"UMS_like_off.png"];
    }
    else {
        bgImage = [UIImage imageNamed:@"UMS_like_on.png"];
        hlImage = [UIImage imageNamed:@"UMS_like_on.png"];
    }
    [_likeButton setImage:bgImage forState:UIControlStateNormal];
    [_likeButton setImage:hlImage forState:UIControlStateHighlighted];
}

-(void)pushShareList
{
    self.socialController.soicalUIDelegate = self;
    UINavigationController *shareListController = [_socialController getSocialShareListController];
    [_tabelViewController presentViewController:shareListController animated:YES completion:nil];
}

-(void)pushCommentList
{
    self.socialController.soicalUIDelegate = self;
    UINavigationController *commentListController = [_socialController getSocialCommentListController];
    [_tabelViewController presentViewController:commentListController animated:YES completion:nil];
}

-(void)didFinishRefreshSocialData:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishRefreshSocialData in UMSocialTableViewCell!!");
    [self handleGetSocilaInformation:response];
}
@end
